package snapshot

import (
	"archive/tar"
	"bytes"
	"context"
	"crypto/md5" //nolint:gosec // Why: Verifiying archives
	"encoding/base64"
	"io"
	"os"
	"os/exec"
	"path/filepath"
	"strconv"
	"strings"
	"time"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/getoutreach/devenv/cmd/devenv/destroy"
	devenvaws "github.com/getoutreach/devenv/pkg/aws"
	"github.com/getoutreach/devenv/pkg/cmdutil"
	"github.com/getoutreach/devenv/pkg/devenvutil"
	"github.com/getoutreach/devenv/pkg/kube"
	"github.com/getoutreach/devenv/pkg/snapshoter"
	"github.com/getoutreach/gobox/pkg/box"
	"github.com/minio/minio-go/v7"
	"github.com/pkg/errors"
	"gopkg.in/yaml.v2"
)

func (o *Options) Generate(ctx context.Context, s *box.SnapshotGenerateConfig, skipUpload bool, channel box.SnapshotLockChannel) error { //nolint:funlen
	b, err := box.LoadBox()
	if err != nil {
		return errors.Wrap(err, "failed to load box configuration")
	}

	o.log.WithField("snapshots", len(s.Targets)).Info("Generating Snapshots")

	copts := devenvaws.DefaultCredentialOptions()
	if b.DeveloperEnvironmentConfig.SnapshotConfig.WriteAWSRole != "" {
		copts.Role = b.DeveloperEnvironmentConfig.SnapshotConfig.WriteAWSRole
	}
	copts.Log = o.log
	err = devenvaws.EnsureValidCredentials(ctx, copts)
	if err != nil {
		return errors.Wrap(err, "failed to get necessary permissions")
	}

	cfg, err := config.LoadDefaultConfig(ctx)
	if err != nil {
		return err
	}
	cfg.Region = b.DeveloperEnvironmentConfig.SnapshotConfig.Region

	s3c := s3.NewFromConfig(cfg)

	lockfile := &box.SnapshotLock{}
	resp, err := s3c.GetObject(ctx, &s3.GetObjectInput{
		Bucket: &b.DeveloperEnvironmentConfig.SnapshotConfig.Bucket,
		Key:    aws.String("automated-snapshots/v2/latest.yaml"),
	})
	if err == nil {
		defer resp.Body.Close()
		err = yaml.NewDecoder(resp.Body).Decode(&lockfile)
		if err != nil {
			return errors.Wrap(err, "failed to parse remote snapshot lockfile")
		}
	} else {
		o.log.WithError(err).
			Warn("Failed to fetch existing remote snapshot lockfile, will generate a new one")
	}

	if lockfile.TargetsV2 == nil {
		lockfile.TargetsV2 = make(map[string]*box.SnapshotLockList)
	}

	for name, t := range s.Targets {
		//nolint:govet // Why: We're OK shadowing err
		itm, err := o.generateSnapshot(ctx, s3c, name, t, skipUpload)
		if err != nil {
			return err
		}

		if _, ok := lockfile.TargetsV2[name]; !ok {
			lockfile.TargetsV2[name] = &box.SnapshotLockList{}
		}

		if lockfile.TargetsV2[name].Snapshots == nil {
			lockfile.TargetsV2[name].Snapshots = make(map[box.SnapshotLockChannel][]*box.SnapshotLockListItem)
		}

		if _, ok := lockfile.TargetsV2[name].Snapshots[channel]; !ok {
			lockfile.TargetsV2[name].Snapshots[channel] = make([]*box.SnapshotLockListItem, 0)
		}

		// Make this the latest version
		lockfile.TargetsV2[name].Snapshots[channel] = append(
			[]*box.SnapshotLockListItem{itm}, lockfile.TargetsV2[name].Snapshots[channel]...,
		)
	}

	// Don't generate a lock if we're not uploading
	if skipUpload {
		return nil
	}

	lockfile.GeneratedAt = time.Now().UTC()

	byt, err := yaml.Marshal(lockfile)
	if err != nil {
		return err
	}

	_, err = s3c.PutObject(ctx, &s3.PutObjectInput{
		Bucket: aws.String("outreach-devenv-snapshots"),
		Key:    aws.String(filepath.Join("automated-snapshots", "v2", "latest.yaml")),
		Body:   bytes.NewReader(byt),
	})
	return err
}

func (o *Options) uploadSnapshot(ctx context.Context, s3c *s3.Client, name string, t *box.SnapshotTarget) (string, string, error) { //nolint:funlen,gocritic
	tmpFile, err := os.CreateTemp("", "snapshot-*")
	if err != nil {
		return "", "", err
	}
	defer os.Remove(tmpFile.Name())

	hash := md5.New() //nolint:gosec // Why: We're just creating a digest
	tw := tar.NewWriter(io.MultiWriter(tmpFile, hash))

	o.k, err = kube.GetKubeClient()
	if err != nil {
		return "", "", err
	}

	mc, err := snapshoter.NewSnapshotBackend(ctx, o.r, o.k)
	if err != nil {
		return "", "", err
	}

	o.log.Info("creating tar archive")
	for obj := range mc.ListObjects(ctx, SnapshotNamespace, minio.ListObjectsOptions{Recursive: true}) {
		// Skip empty keys
		if strings.EqualFold(obj.Key, "") {
			continue
		}

		sObj, err := mc.GetObject(ctx, SnapshotNamespace, obj.Key, minio.GetObjectOptions{}) //nolint:govet
		if err != nil {
			return "", "", errors.Wrap(err, "failed to get object from local S3")
		}

		info, err := sObj.Stat()
		if err != nil {
			return "", "", errors.Wrap(err, "failed to stat object")
		}

		err = tw.WriteHeader(&tar.Header{
			Typeflag:   tar.TypeReg,
			Name:       info.Key,
			Size:       info.Size,
			Mode:       0755,
			ModTime:    info.LastModified,
			AccessTime: info.LastModified,
			ChangeTime: info.LastModified,
		})
		if err != nil {
			return "", "", errors.Wrap(err, "failed to write tar header")
		}

		_, err = io.Copy(tw, sObj)
		if err != nil {
			return "", "", errors.Wrap(err, "failed to download object from local S3")
		}
	}

	// If we have post-restore manifests, then include them in the archive at a well-known
	// path for post-processing on runtime
	if t.PostRestore != "" {
		f, err := os.Open(t.PostRestore) //nolint:govet // Why: We're OK shadowing err.
		if err != nil {
			return "", "", errors.Wrap(err, "failed to open post-restore file")
		}

		inf, err := f.Stat()
		if err != nil {
			return "", "", errors.Wrap(err, "failed to stat post-restore file")
		}

		header, err := tar.FileInfoHeader(inf, "")
		if err != nil {
			return "", "", errors.Wrap(err, "failed to create tar header")
		}
		header.Name = "post-restore/manifests.yaml"

		err = tw.WriteHeader(header)
		if err != nil {
			return "", "", errors.Wrap(err, "failed to write tar header")
		}

		_, err = io.Copy(tw, f)
		if err != nil {
			return "", "", errors.Wrap(err, "failed to write post-restore file to archive")
		}
	}

	if err := tw.Close(); err != nil { //nolint:govet // Why: we're OK shadowing err
		return "", "", err
	}
	if err := tmpFile.Close(); err != nil { //nolint:govet // Why: we're OK shadowing err
		return "", "", err
	}

	hashStr := base64.StdEncoding.EncodeToString(hash.Sum(nil))
	key := filepath.Join("automated-snapshots", "v2", name, strconv.Itoa(int(time.Now().UTC().UnixNano()))+".tar")

	tmpFile, err = os.Open(tmpFile.Name())
	if err != nil {
		return "", "", err
	}

	o.log.Info("uploading tar archive")
	_, err = s3c.PutObject(ctx, &s3.PutObjectInput{
		Bucket:     aws.String("outreach-devenv-snapshots"),
		Key:        &key,
		Body:       tmpFile,
		ContentMD5: &hashStr,
	})
	if err != nil {
		return "", "", err
	}

	return hashStr, key, nil
}

//nolint:funlen
func (o *Options) generateSnapshot(ctx context.Context, s3c *s3.Client,
	name string, t *box.SnapshotTarget, skipUpload bool) (*box.SnapshotLockListItem, error) {
	o.log.WithField("snapshot", name).Info("Generating Snapshot")

	destroyOpts, err := destroy.NewOptions(o.log)
	if err != nil {
		return nil, errors.Wrap(err, "failed to create destroy command")
	}
	destroyOpts.RemoveImageCache = true
	destroyOpts.Run(ctx) //nolint:errcheck

	// using exec because of an import cycle, need to fix
	os.Setenv("DEVENV_SNAPSHOT_GENERATION", "true") //nolint:errcheck
	err = cmdutil.RunKubernetesCommand(ctx, "", false, os.Args[0], "--skip-update", "provision",
		"--base", "--kubernetes-runtime", "kind")
	if err != nil {
		return nil, errors.Wrap(err, "failed to provision developer environment")
	}

	if len(t.DeployApps) != 0 {
		o.log.Info("Deploying applications into devenv")
		for _, app := range t.DeployApps {
			o.log.WithField("application", app).Info("Deploying application")
			cmd := exec.CommandContext(ctx, os.Args[0], "--skip-update", "deploy-app", app) //nolint:gosec
			cmd.Stderr = os.Stderr
			cmd.Stdout = os.Stdout
			cmd.Stdin = os.Stdin
			if err := cmd.Run(); err != nil { //nolint:govet // Why: We're OK shadowing err.
				return nil, errors.Wrap(err, "failed to deploy application")
			}
		}
	}

	if t.Command != "" {
		o.log.Info("Running snapshot generation command")
		err = cmdutil.RunKubernetesCommand(ctx, "", false, "/bin/bash", "-c", t.Command)
		if err != nil {
			return nil, errors.Wrap(err, "failed to run snapshot supplied command")
		}
	}

	if len(t.PostDeployApps) != 0 {
		o.log.Info("Deploying applications into devenv")
		for _, app := range t.PostDeployApps {
			o.log.WithField("application", app).Info("Deploying application")
			cmd := exec.CommandContext(ctx, os.Args[0], "--skip-update", "deploy-app", app) //nolint:gosec
			cmd.Stderr = os.Stderr
			cmd.Stdout = os.Stdout
			cmd.Stdin = os.Stdin
			if err := cmd.Run(); err != nil { //nolint:govet // Why: We're OK shadowing err.
				return nil, errors.Wrap(err, "failed to deploy application")
			}
		}
	}

	// Need to create a new Kubernetes client that uses the new cluster
	o, err = NewOptions(o.log)
	if err != nil {
		return nil, errors.Wrap(err, "failed to create new clients")
	}

	err = devenvutil.WaitForAllPodsToBeReady(ctx, o.k, o.log)
	if err != nil {
		return nil, err
	}

	veleroBackupName, err := o.CreateSnapshot(ctx)
	if err != nil {
		return nil, err
	}

	hash := "unknown"
	key := "unknown"
	if !skipUpload {
		hash, key, err = o.uploadSnapshot(ctx, s3c, name, t)
		if err != nil {
			return nil, errors.Wrap(err, "failed to upload snapshot")
		}
	}

	return &box.SnapshotLockListItem{
		Digest:           hash,
		URI:              key,
		Config:           t,
		VeleroBackupName: veleroBackupName,
	}, nil
}

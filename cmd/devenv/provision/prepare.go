package provision

import (
	"context"
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
	"strings"
	"time"

	"github.com/getoutreach/devenv/internal/vault"
	"github.com/getoutreach/devenv/pkg/app"
	"github.com/getoutreach/devenv/pkg/cmdutil"
	"github.com/getoutreach/devenv/pkg/devenvutil"
	"github.com/getoutreach/devenv/pkg/embed"
	"github.com/getoutreach/devenv/pkg/kubernetesruntime"
	"github.com/getoutreach/gobox/pkg/async"
	"github.com/pkg/errors"
)

func (o *Options) deployStage(ctx context.Context, stage string) error { //nolint:funlen
	dir, err := o.extractEmbed(ctx)
	if err != nil {
		return err
	}
	defer os.RemoveAll(dir)

	stageDir := filepath.Join(dir, "manifests", stage)

	files, err := os.ReadDir(stageDir)
	if err != nil {
		return errors.Wrap(err, "failed to list files in extracted embed dir")
	}

	runtimeConf := o.KubernetesRuntime.GetConfig()

	for _, f := range files {
		o.log.WithField("manifest", f.Name()).Info("Deploying Manifest")

		attempts := 0
		for ctx.Err() == nil {
			if attempts > 3 {
				return fmt.Errorf("ran out of attempts")
			}

			//nolint:govet // Why: we're OK shadowing err
			err = cmdutil.RunKubernetesCommand(ctx, stageDir, true, "kubecfg",
				"--jurl", "https://raw.githubusercontent.com/getoutreach/jsonnet-libs/master", "update",
				"--ignore-unknown", // We need to skip CRD objects, they may be created on first run
				"--ext-str", fmt.Sprintf("cluster_type=%s", runtimeConf.Type),
				"--ext-str", fmt.Sprintf("cluster_name=%s", runtimeConf.ClusterName),
				"--ext-str", fmt.Sprintf("vault_addr=%s", o.b.DeveloperEnvironmentConfig.VaultConfig.Address),
				f.Name(),
			)
			if err == nil {
				break
			}

			attempts++
			o.log.WithError(err).Warn("Failed to apply manifests, retrying ...")

			async.Sleep(ctx, time.Second*2)
		}
		if ctx.Err() != nil {
			return ctx.Err()
		}
	}

	if o.b.DeveloperEnvironmentConfig.VaultConfig.Enabled {
		err = vault.EnsureLoggedIn(ctx, o.log, o.b, o.k)
		if err != nil {
			return errors.Wrap(err, "failed to ensure vault had valid credentials")
		}
	}

	err = devenvutil.WaitForAllPodsToBeReady(ctx, o.k, o.log)
	if err != nil {
		return errors.Wrap(err, "failed to wait for pods to be ready w")
	}

	// Deploy resourcer if we're a local runtime, we can only run things on a single node
	// so we should mutate all pods to have zero resources.
	// Special exeception is when we're generating snapshots.
	if o.KubernetesRuntime.GetConfig().Type == kubernetesruntime.RuntimeTypeLocal && os.Getenv("DEVENV_SNAPSHOT_GENERATION") == "" {
		err := app.Deploy(ctx, o.log, o.k, o.r, "resourcer", o.KubernetesRuntime.GetConfig())
		if err != nil {
			return errors.Wrap(err, "failed to deploy resourcer")
		}
	}

	return nil
}

// extractEmbed wraps embed.ExtractAllToTempDir but handles cleaning up the dir
// if failed
func (o *Options) extractEmbed(ctx context.Context) (string, error) {
	dir, err := embed.ExtractAllToTempDir(ctx)
	if err != nil {
		if dir != "" {
			//nolint:errcheck
			os.RemoveAll(dir)
		}
		return "", err
	}

	return dir, err
}

func (o *Options) ensureImagePull(ctx context.Context) error {
	if !o.b.DeveloperEnvironmentConfig.VaultConfig.Enabled {
		return nil
	}

	if o.b.DeveloperEnvironmentConfig.ImagePullSecret == "" {
		return nil
	}

	// We need to take the user's key and inject data after the KV store, e.g.
	// dev/devenv/image-pull-secret becomes dev/data/devenv/...
	paths := strings.Split(o.b.DeveloperEnvironmentConfig.ImagePullSecret, "/")
	secretPath := strings.Join(append([]string{paths[0], "data"}, paths[1:]...), "/")

	storagePath := filepath.Join(o.homeDir, imagePullSecretPath)
	if _, err := os.Stat(storagePath); err == nil {
		// we already have it, so exit
		return nil
	}

	o.log.WithField("secretPath", secretPath).Info("Fetching image pull secret via Vault")
	if err := vault.EnsureLoggedIn(ctx, o.log, o.b, nil); err != nil {
		return errors.Wrap(err, "failed to login to vault")
	}

	v, err := vault.NewClient(ctx, o.b)
	if err != nil {
		return errors.Wrap(err, "failed to create vault client")
	}

	sec, err := v.Logical().Read(secretPath)
	if err != nil {
		return errors.Wrap(err, "failed to read image pull secret from Vault")
	}

	imageSecret := sec.Data["data"].(map[string]interface{})["secret"].(string)

	err = os.MkdirAll(filepath.Dir(storagePath), 0755)
	if err != nil {
		return err
	}

	return ioutil.WriteFile(storagePath, []byte(imageSecret), 0600)
}

module github.com/getoutreach/devenv

go 1.17

require (
	github.com/aws/aws-sdk-go-v2 v1.9.2
	github.com/aws/aws-sdk-go-v2/config v1.8.3
	github.com/aws/aws-sdk-go-v2/service/s3 v1.15.1
	github.com/cenkalti/backoff/v4 v4.1.1
	github.com/docker/docker v20.10.5+incompatible
	github.com/getoutreach/gobox v1.18.1
	github.com/getoutreach/localizer v1.12.0
	github.com/google/btree v1.0.1 // indirect
	github.com/gregjones/httpcache v0.0.0-20190611155906-901d90724c79 // indirect
	github.com/hashicorp/vault/api v1.1.1
	github.com/jetstack/cert-manager v1.5.4
	github.com/jonboulle/clockwork v0.2.2 // indirect

	// Note: Currently can't use v1.15 because of a private dependency
	// being `replace`-d.
	github.com/loft-sh/api v1.14.0
	github.com/loft-sh/loftctl v1.14.0
	github.com/manifoldco/promptui v0.8.0
	github.com/matryer/is v1.4.0 // indirect
	github.com/minio/minio-go/v7 v7.0.14
	github.com/mitchellh/go-wordwrap v1.0.1
	github.com/novln/docker-parser v1.0.0
	github.com/pkg/errors v0.9.1
	github.com/schollz/progressbar/v3 v3.8.3
	github.com/sirupsen/logrus v1.8.1
	github.com/urfave/cli/v2 v2.3.0
	github.com/versent/saml2aws/v2 v2.32.0
	github.com/vmware-tanzu/velero v1.7.0
	google.golang.org/genproto v0.0.0-20210716133855-ce7ef5c701ea // indirect
	google.golang.org/grpc v1.41.0
	gopkg.in/yaml.v2 v2.4.0
	gopkg.in/yaml.v3 v3.0.0-20210107192922-496545a6307b

	// Kubernetes dependencies
	// Ensure that the versions here are always the same
	// and that the replace directives are updated to match.
	// Current version: v0.21.3
	k8s.io/api v0.21.3
	k8s.io/apimachinery v0.21.3
	k8s.io/cli-runtime v0.22.2
	k8s.io/client-go v0.21.3
	k8s.io/component-base v0.21.3
	k8s.io/kubectl v0.21.3
)

require (
	github.com/AlecAivazis/survey/v2 v2.3.2 // indirect
	github.com/Azure/go-ansiterm v0.0.0-20170929234023-d6e3b3328b78 // indirect
	github.com/MakeNowJust/heredoc v1.0.0 // indirect
	github.com/Microsoft/go-winio v0.5.0 // indirect
	github.com/NYTimes/gziphandler v1.1.1 // indirect
	github.com/ProtonMail/go-crypto v0.0.0-20210428141323-04723f9f07d7 // indirect
	github.com/PuerkitoBio/purell v1.1.1 // indirect
	github.com/PuerkitoBio/urlesc v0.0.0-20170810143723-de5bf2ad4578 // indirect
	github.com/acomagu/bufpipe v1.0.3 // indirect
	github.com/aws/aws-sdk-go-v2/credentials v1.4.3 // indirect
	github.com/aws/aws-sdk-go-v2/feature/ec2/imds v1.6.0 // indirect
	github.com/aws/aws-sdk-go-v2/internal/ini v1.2.4 // indirect
	github.com/aws/aws-sdk-go-v2/service/internal/accept-encoding v1.3.0 // indirect
	github.com/aws/aws-sdk-go-v2/service/internal/presigned-url v1.3.2 // indirect
	github.com/aws/aws-sdk-go-v2/service/internal/s3shared v1.7.0 // indirect
	github.com/aws/aws-sdk-go-v2/service/sso v1.4.2 // indirect
	github.com/aws/aws-sdk-go-v2/service/sts v1.7.2 // indirect
	github.com/aws/smithy-go v1.8.0 // indirect
	github.com/beorn7/perks v1.0.1 // indirect
	github.com/blang/semver v3.5.1+incompatible // indirect
	github.com/blang/semver/v4 v4.0.0 // indirect
	github.com/cenkalti/backoff/v3 v3.0.0 // indirect
	github.com/cespare/xxhash/v2 v2.1.1 // indirect
	github.com/chai2010/gettext-go v0.0.0-20160711120539-c6fed771bfd5 // indirect
	github.com/chzyer/readline v0.0.0-20180603132655-2972be24d48e // indirect
	github.com/containerd/containerd v1.5.0-beta.1 // indirect
	github.com/coreos/go-semver v0.3.0 // indirect
	github.com/coreos/go-systemd v0.0.0-20190719114852-fd7a80b32e1f // indirect
	github.com/coreos/pkg v0.0.0-20180928190104-399ea9e2e55f // indirect
	github.com/cpuguy83/go-md2man/v2 v2.0.0 // indirect
	github.com/danieljoos/wincred v1.1.0 // indirect
	github.com/davecgh/go-spew v1.1.1 // indirect
	github.com/daviddengcn/go-colortext v0.0.0-20160507010035-511bcaf42ccd // indirect
	github.com/docker/distribution v2.7.1+incompatible // indirect
	github.com/docker/go-connections v0.4.0 // indirect
	github.com/docker/go-units v0.4.0 // indirect
	github.com/dustin/go-humanize v1.0.0 // indirect
	github.com/emicklei/go-restful v2.9.5+incompatible // indirect
	github.com/emirpasic/gods v1.12.0 // indirect
	github.com/evanphx/json-patch v4.11.0+incompatible // indirect
	github.com/exponent-io/jsonpath v0.0.0-20151013193312-d6023ce2651d // indirect
	github.com/facebookgo/clock v0.0.0-20150410010913-600d898af40a // indirect
	github.com/facebookgo/limitgroup v0.0.0-20150612190941-6abd8d71ec01 // indirect
	github.com/facebookgo/muster v0.0.0-20150708232844-fd3d7953fd52 // indirect
	github.com/fatih/camelcase v1.0.0 // indirect
	github.com/fsnotify/fsnotify v1.4.9 // indirect
	github.com/fvbommel/sortorder v1.0.1 // indirect
	github.com/go-errors/errors v1.0.1 // indirect
	github.com/go-git/gcfg v1.5.0 // indirect
	github.com/go-git/go-billy/v5 v5.3.1 // indirect
	github.com/go-git/go-git/v5 v5.4.2 // indirect
	github.com/go-logr/logr v0.4.0 // indirect
	github.com/go-openapi/jsonpointer v0.19.5 // indirect
	github.com/go-openapi/jsonreference v0.19.5 // indirect
	github.com/go-openapi/spec v0.20.1 // indirect
	github.com/go-openapi/swag v0.19.13 // indirect
	github.com/godbus/dbus/v5 v5.0.4 // indirect
	github.com/gogo/protobuf v1.3.2 // indirect
	github.com/golang/groupcache v0.0.0-20200121045136-8c9f03a8e57e // indirect
	github.com/golang/protobuf v1.5.2 // indirect
	github.com/golang/snappy v0.0.3 // indirect
	github.com/google/go-cmp v0.5.6 // indirect
	github.com/google/go-github/v34 v34.0.0 // indirect
	github.com/google/go-querystring v1.0.0 // indirect
	github.com/google/gofuzz v1.2.0 // indirect
	github.com/google/shlex v0.0.0-20191202100458-e7afc7fbc510 // indirect
	github.com/google/uuid v1.3.0 // indirect
	github.com/googleapis/gnostic v0.5.5 // indirect
	github.com/grpc-ecosystem/go-grpc-middleware v1.3.0 // indirect
	github.com/grpc-ecosystem/go-grpc-prometheus v1.2.0 // indirect
	github.com/hashicorp/errwrap v1.0.0 // indirect
	github.com/hashicorp/go-cleanhttp v0.5.1 // indirect
	github.com/hashicorp/go-multierror v1.1.0 // indirect
	github.com/hashicorp/go-retryablehttp v0.6.6 // indirect
	github.com/hashicorp/go-rootcerts v1.0.2 // indirect
	github.com/hashicorp/go-sockaddr v1.0.2 // indirect
	github.com/hashicorp/golang-lru v0.5.4 // indirect
	github.com/hashicorp/hcl v1.0.0 // indirect
	github.com/hashicorp/vault/sdk v0.2.1 // indirect
	github.com/honeycombio/beeline-go v1.2.0 // indirect
	github.com/honeycombio/libhoney-go v1.15.4 // indirect
	github.com/imdario/mergo v0.3.12 // indirect
	github.com/inconshreveable/go-update v0.0.0-20160112193335-8152e7eb6ccf // indirect
	github.com/inconshreveable/mousetrap v1.0.0 // indirect
	github.com/jbenet/go-context v0.0.0-20150711004518-d14ea06fba99 // indirect
	github.com/josharian/intern v1.0.0 // indirect
	github.com/json-iterator/go v1.1.11 // indirect
	github.com/juju/ansiterm v0.0.0-20180109212912-720a0952cc2a // indirect
	github.com/k0kubun/go-ansi v0.0.0-20180517002512-3bf9e2903213 // indirect
	github.com/kballard/go-shellquote v0.0.0-20180428030007-95032a82bc51 // indirect
	github.com/kevinburke/ssh_config v1.1.0 // indirect
	github.com/klauspost/compress v1.12.3 // indirect
	github.com/klauspost/cpuid v1.3.1 // indirect
	github.com/liggitt/tabwriter v0.0.0-20181228230101-89fcab3d43de // indirect
	github.com/lithammer/dedent v1.1.0 // indirect
	github.com/loft-sh/apiserver v0.0.0-20210607160412-10c99558fdeb // indirect
	github.com/loft-sh/jspolicy v0.1.0 // indirect
	github.com/loft-sh/kiosk v0.2.7 // indirect
	github.com/lunixbochs/vtclean v0.0.0-20180621232353-2d01aacdc34a // indirect
	github.com/mailru/easyjson v0.7.6 // indirect
	github.com/mattn/go-colorable v0.1.8 // indirect
	github.com/mattn/go-isatty v0.0.14 // indirect
	github.com/mattn/go-runewidth v0.0.13 // indirect
	github.com/matttproud/golang_protobuf_extensions v1.0.2-0.20181231171920-c182affec369 // indirect
	github.com/mgutz/ansi v0.0.0-20200706080929-d51e80ef957d // indirect
	github.com/minio/md5-simd v1.1.0 // indirect
	github.com/minio/sha256-simd v0.1.1 // indirect
	github.com/mitchellh/colorstring v0.0.0-20190213212951-d06e56a500db // indirect
	github.com/mitchellh/go-homedir v1.1.0 // indirect
	github.com/mitchellh/mapstructure v1.4.1 // indirect
	github.com/moby/spdystream v0.2.0 // indirect
	github.com/moby/term v0.0.0-20201216013528-df9cb8a40635 // indirect
	github.com/modern-go/concurrent v0.0.0-20180306012644-bacd9c7ef1dd // indirect
	github.com/modern-go/reflect2 v1.0.1 // indirect
	github.com/monochromegane/go-gitignore v0.0.0-20200626010858-205db1a8cc00 // indirect
	github.com/munnerz/goautoneg v0.0.0-20191010083416-a7dc8b61c822 // indirect
	github.com/mxk/go-flowrate v0.0.0-20140419014527-cca7078d478f // indirect
	github.com/opencontainers/go-digest v1.0.0 // indirect
	github.com/opencontainers/image-spec v1.0.1 // indirect
	github.com/peterbourgon/diskv v2.0.1+incompatible // indirect
	github.com/pierrec/lz4 v2.5.2+incompatible // indirect
	github.com/pmezard/go-difflib v1.0.0 // indirect
	github.com/prometheus/client_golang v1.11.0 // indirect
	github.com/prometheus/client_model v0.2.0 // indirect
	github.com/prometheus/common v0.26.0 // indirect
	github.com/prometheus/procfs v0.6.0 // indirect
	github.com/rivo/uniseg v0.2.0 // indirect
	github.com/rs/xid v1.2.1 // indirect
	github.com/russross/blackfriday v1.5.2 // indirect
	github.com/russross/blackfriday/v2 v2.1.0 // indirect
	github.com/ryanuber/go-glob v1.0.0 // indirect
	github.com/sergi/go-diff v1.2.0 // indirect
	github.com/skratchdot/open-golang v0.0.0-20200116055534-eef842397966 // indirect
	github.com/spf13/cobra v1.2.1 // indirect
	github.com/spf13/pflag v1.0.5 // indirect
	github.com/stretchr/testify v1.7.0 // indirect
	github.com/vmihailenco/msgpack/v5 v5.2.0 // indirect
	github.com/vmihailenco/tagparser/v2 v2.0.0 // indirect
	github.com/xanzy/ssh-agent v0.3.0 // indirect
	github.com/xlab/treeprint v0.0.0-20181112141820-a009c3971eca // indirect
	github.com/zalando/go-keyring v0.1.1 // indirect
	go.etcd.io/etcd v0.5.0-alpha.5.0.20200910180754-dd1b699fc489 // indirect
	go.opentelemetry.io/contrib/propagators v0.21.0 // indirect
	go.opentelemetry.io/otel v1.0.0-RC1 // indirect
	go.opentelemetry.io/otel/trace v1.0.0-RC1 // indirect
	go.starlark.net v0.0.0-20201006213952-227f4aabceb5 // indirect
	go.uber.org/atomic v1.7.0 // indirect
	go.uber.org/multierr v1.6.0 // indirect
	go.uber.org/zap v1.17.0 // indirect
	golang.org/x/crypto v0.0.0-20210817164053-32db794688a5 // indirect
	golang.org/x/net v0.0.0-20210805182204-aaa1db679c0d // indirect
	golang.org/x/oauth2 v0.0.0-20210628180205-a41e5a781914 // indirect
	golang.org/x/sync v0.0.0-20210220032951-036812b2e83c // indirect
	golang.org/x/sys v0.0.0-20210910150752-751e447fb3d0 // indirect
	golang.org/x/term v0.0.0-20210615171337-6886f2dfbf5b // indirect
	golang.org/x/text v0.3.6 // indirect
	golang.org/x/time v0.0.0-20210611083556-38a9dc6acbc6 // indirect
	gomodules.xyz/jsonpatch/v2 v2.2.0 // indirect
	google.golang.org/appengine v1.6.7 // indirect
	google.golang.org/protobuf v1.27.1 // indirect
	gopkg.in/AlecAivazis/survey.v1 v1.8.8 // indirect
	gopkg.in/alexcesaro/statsd.v2 v2.0.0 // indirect
	gopkg.in/inf.v0 v0.9.1 // indirect
	gopkg.in/ini.v1 v1.62.0 // indirect
	gopkg.in/square/go-jose.v2 v2.5.1 // indirect
	gopkg.in/warnings.v0 v0.1.2 // indirect
	k8s.io/apiextensions-apiserver v0.21.3 // indirect
	k8s.io/apiserver v0.21.3 // indirect
	k8s.io/component-helpers v0.21.3 // indirect
	k8s.io/klog/v2 v2.9.0 // indirect
	k8s.io/kube-aggregator v0.21.3 // indirect
	k8s.io/kube-openapi v0.0.0-20210527164424-3c818078ee3d // indirect
	k8s.io/metrics v0.21.3 // indirect
	k8s.io/utils v0.0.0-20210802155522-efc7438f0176 // indirect
	sigs.k8s.io/apiserver-network-proxy/konnectivity-client v0.0.19 // indirect
	sigs.k8s.io/controller-runtime v0.9.2 // indirect
	sigs.k8s.io/kustomize/api v0.8.8 // indirect
	sigs.k8s.io/kustomize/kustomize/v4 v4.1.2 // indirect
	sigs.k8s.io/kustomize/kyaml v0.10.17 // indirect
	sigs.k8s.io/structured-merge-diff/v4 v4.1.2 // indirect
	sigs.k8s.io/yaml v1.2.0 // indirect
)

replace (
	// Incompat w/ loft: see https://github.com/google/trillian/issues/2195
	// and https://github.com/kubernetes-sigs/controller-runtime/issues/1498
	github.com/googleapis/gnostic => github.com/googleapis/gnostic v0.4.1
	google.golang.org/grpc => google.golang.org/grpc v1.29.1

	// Ensure we use the same k8s version everywhere
	k8s.io/api => k8s.io/api v0.21.3
	k8s.io/apiextensions-apiserver => k8s.io/apiextensions-apiserver v0.21.3
	k8s.io/apimachinery => k8s.io/apimachinery v0.21.3
	k8s.io/apiserver => k8s.io/apiserver v0.21.3
	k8s.io/cli-runtime => k8s.io/cli-runtime v0.21.3
	k8s.io/client-go => k8s.io/client-go v0.21.3
	k8s.io/cloud-provider => k8s.io/cloud-provider v0.21.3
	k8s.io/cluster-bootstrap => k8s.io/cluster-bootstrap v0.21.3
	k8s.io/code-generator => k8s.io/code-generator v0.21.3
	k8s.io/component-base => k8s.io/component-base v0.21.3
	k8s.io/component-helpers => k8s.io/component-helpers v0.21.3
	k8s.io/controller-manager => k8s.io/controller-manager v0.21.3
	k8s.io/cri-api => k8s.io/cri-api v0.21.3
	k8s.io/csi-translation-lib => k8s.io/csi-translation-lib v0.21.3
	k8s.io/kube-aggregator => k8s.io/kube-aggregator v0.21.3
	k8s.io/kube-controller-manager => k8s.io/kube-controller-manager v0.21.3
	k8s.io/kube-openapi => k8s.io/kube-openapi v0.0.0-20210305001622-591a79e4bda7
	k8s.io/kube-proxy => k8s.io/kube-proxy v0.21.3
	k8s.io/kube-scheduler => k8s.io/kube-scheduler v0.21.3
	k8s.io/kubectl => k8s.io/kubectl v0.21.3
	k8s.io/kubelet => k8s.io/kubelet v0.21.3
	k8s.io/kubernetes => k8s.io/kubernetes v1.20.5
	k8s.io/legacy-cloud-providers => k8s.io/legacy-cloud-providers v0.21.3
	k8s.io/metrics => k8s.io/metrics v0.21.3
	k8s.io/mount-utils => k8s.io/mount-utils v0.21.3
	k8s.io/sample-apiserver => k8s.io/sample-apiserver v0.21.3
)

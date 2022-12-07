#[ -d ./spack ] || git clone -c feature.manyFiles=true --branch releases/latest git@github.com:benkirk/spack.git
[ -d ./spack ] || git clone -c feature.manyFiles=true git@github.com:benkirk/spack.git

. ../sanitze_env.sh

. spack/share/spack/setup-env.sh

type spack >/dev/null 2>&1 || exit 1

spack config add "config:install_tree:padded_length: 128"

spack config blame config

spack debug report

spack maintainers util-linux-uuid

spack spec -I util-linux-uuid
spack install -v util-linux-uuid

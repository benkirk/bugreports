#[ -d ./spack ] || git clone -c feature.manyFiles=true --branch releases/latest git@github.com:benkirk/spack.git
[ -d ./spack ] || git clone -c feature.manyFiles=true git@github.com:benkirk/spack.git

. ./config_env.sh || exit 1

spack external find --not-buildable ncurses

spack config blame packages
spack config blame concretizer
spack config blame config

spack debug report

spack maintainers perl

spack spec -I perl
spack add perl
spack concretize
spack install

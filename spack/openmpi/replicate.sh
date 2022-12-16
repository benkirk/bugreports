[ -d ./spack ] || git clone -c feature.manyFiles=true --branch releases/v0.19 https://github.com/spack/spack.git

. ./config_env.sh || exit 1

spack config blame packages
spack config blame concretizer
spack config blame config
spack compilers

spack debug report

spack maintainers openmpi

pkg="openmpi@4.1.4%gcc@4.8.5 fabrics=ofi"
spack spec -I ${pkg}
spack add ${pkg}
spack install

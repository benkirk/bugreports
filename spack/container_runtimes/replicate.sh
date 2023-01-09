[ -d ./spack ] || git clone -c feature.manyFiles=true --branch releases/v0.19-BSK git@github.com:benkirk/spack.git
#[ -d ./spack ] || git clone -c feature.manyFiles=true --branch gimp_updates git@github.com:benkirk/spack.git

. ./config_env.sh || exit 1

spack config add "config:install_tree:padded_length: 0"

for arg in repos mirrors concretizer packages config modules compilers; do
    spack config blame ${arg} && echo && echo # show our current configuration, with what comes from where
done

spack debug report

spack maintainers charliecloud


spack add charliecloud+squash^libfuse~utils singularityce~suid podman@4 slirp4netns

spack concretize --fresh

# populate our source cache mirror
spack mirror create --directory ${SCRATCH}/spack_caches/source --all

spack install --deprecated --no-check-signature & spack install --deprecated --no-check-signature & spack install --deprecated --no-check-signature & spack install --deprecated --no-check-signature
wait
spack install --verbose --deprecated --no-check-signature || exit 1

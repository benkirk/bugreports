[ -d ./spack ] || git clone -c feature.manyFiles=true --branch releases/v0.19-BSK git@github.com:benkirk/spack.git

. ./config_env.sh || exit 1

spack external find perl openssh
spack config add "config:install_tree:padded_length: 128"

for arg in repos mirrors concretizer packages config modules compilers; do
    spack config blame ${arg} && echo && echo # show our current configuration, with what comes from where
done

spack debug report

spack maintainers peak-memusage

spack add peak-memusage+doc

spack concretize --fresh

# populate our source cache mirror
spack mirror create --directory ${SCRATCH}/spack_caches/source --all

spack install --deprecated --no-check-signature & spack install --deprecated --no-check-signature & spack install --deprecated --no-check-signature & spack install --deprecated --no-check-signature
wait
spack install --verbose --deprecated --no-check-signature || exit 1

spack module lmod refresh --delete-tree --yes-to-all

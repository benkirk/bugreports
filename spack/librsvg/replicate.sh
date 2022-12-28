[ -d ./spack ] || git clone -c feature.manyFiles=true --branch librsvg_backports git@github.com:benkirk/spack.git
#[ -d ./spack ] || git clone -c feature.manyFiles=true git@github.com:benkirk/spack.git

. ./config_env.sh || exit 1

spack config add "config:install_tree:padded_length: 0"

for arg in repos mirrors concretizer packages config modules compilers; do
    spack config blame ${arg} && echo && echo # show our current configuration, with what comes from where
done

spack debug report

spack maintainers librsvg

spack add librsvg@2.40.21 librsvg@2.44.14 librsvg@2.50.2 librsvg@2.51.0
spack concretize --fresh
spack install --no-cache --no-check-signature & spack install --no-cache --no-check-signature & spack install --no-cache --no-check-signature & spack install --no-cache --no-check-signature
wait
spack install --verbose --no-cache --deprecated --no-check-signature || exit 1
exit 0

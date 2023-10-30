[ -d ./spack ] || git clone -c feature.manyFiles=true git@github.com:benkirk/spack.git

. ./config_env.sh || exit 1

#spack config add "config:install_tree:padded_length: 0"

for arg in repos mirrors concretizer packages config modules compilers; do
    spack config blame ${arg} && echo && echo # show our current configuration, with what comes from where
done

spack debug report

spack maintainers emacs

spack add cups

spack concretize --fresh
# populate our source cache mirror
spack mirror create --directory ${SCRATCH}/spack_caches/source --all

for cnt in $(seq 1 5); do
    spack install &
done
wait

spack add \
      emacs+X \
      vim+cscope+x+gui features=huge

spack concretize --fresh
# populate our source cache mirror
spack mirror create --directory ${SCRATCH}/spack_caches/source --all

for cnt in $(seq 1 5); do
    spack install &
done
wait

#spack install --verbose || exit 1

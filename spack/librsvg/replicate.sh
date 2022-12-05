[ -d ./spack ] || git clone -c feature.manyFiles=true --branch releases/v0.19 https://github.com/spack/spack.git

. ../sanitze_env.sh

. spack/share/spack/setup-env.sh 

type spack >/dev/null 2>&1 || exit 1

#spack config add "config:install_tree:padded_length: 128"

spack config blame packages
spack config blame config

spack debug report

spack maintainers librsvg

spack spec -I librsvg ^perl@5.16.3~cpanm+shared+threads ^python@3.9
spack install librsvg ^perl@5.16.3~cpanm+shared+threads ^python@3.9

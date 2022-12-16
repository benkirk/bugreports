. ../sanitze_env.sh

. spack/share/spack/setup-env.sh

type spack >/dev/null 2>&1 || exit 1

spack env create testenv 2>/dev/null
spack env activate testenv || exit 1

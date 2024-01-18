#. ../sanitze_env.sh

# process any command line args:
remove_env=true

while [[ $# -gt 0 ]]; do
    case $1 in
        -k|--keep-env)
            remove_env=false
            ;;
        *)
            ;;
    esac
    shift
done

. spack/share/spack/setup-env.sh

#[ -x /glade/u/apps/opt/conda/envs/npl/bin/python3 ] && export SPACK_PYTHON=/glade/u/apps/opt/conda/envs/npl/bin/python3

#echo $SPACK_PYTHON

type spack >/dev/null 2>&1 || exit 1

cat > spack.yaml <<EOF
spack:
  config:
    source_cache: ${SCRATCH}/spack_caches/source
  concretizer:
    unify: false
    targets:
      granularity: generic
  packages:
    all:
      target: [x86_64]
EOF

spack_env="FUSE_env"

if [[ true == ${remove_env} ]]; then
    spack env remove -y ${spack_env} 2>/dev/null
    spack env create ${spack_env} ./spack.yaml 2>/dev/null
fi
spack env activate -p ${spack_env} || exit 1

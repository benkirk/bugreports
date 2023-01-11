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

[ -x /glade/u/apps/opt/conda/envs/npl/bin/python3 ] && export SPACK_PYTHON=/glade/u/apps/opt/conda/envs/npl/bin/python3

echo $SPACK_PYTHON

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

found=false
for try_path in CentOS Gust ; do
    [ -x /glade/work/benkirk/my_spack_playground/deploy/view/${try_path}-compilers/gcc/11.3.0/bin/gcc ] && \
        found=true && \
        cat >> spack.yaml <<EOF
  compilers:
  - compiler:
      spec: gcc@11.3.0
      paths:
        cc: /glade/work/benkirk/my_spack_playground/deploy/view/${try_path}-compilers/gcc/11.3.0/bin/gcc
        cxx: /glade/work/benkirk/my_spack_playground/deploy/view/${try_path}-compilers/gcc/11.3.0/bin/g++
        f77: /glade/work/benkirk/my_spack_playground/deploy/view/${try_path}-compilers/gcc/11.3.0/bin/gfortran
        fc: /glade/work/benkirk/my_spack_playground/deploy/view/${try_path}-compilers/gcc/11.3.0/bin/gfortran
      flags:
        ldflags: -L/glade/work/benkirk/my_spack_playground/deploy/view/${try_path}-compilers/gcc/11.3.0/lib64
      operating_system: $(spack arch -o)
      target: x86_64
      modules: []
      environment: {}
      extra_rpaths:
        - /glade/work/benkirk/my_spack_playground/deploy/view/${try_path}-compilers/gcc/11.3.0/lib64

EOF
    [[ true == ${found} ]] && break
done

if [[ true == ${remove_env} ]]; then
    spack env remove -y criu_env 2>/dev/null
    spack env create criu_env ./spack.yaml 2>/dev/null
fi
spack env activate -p criu_env || exit 1

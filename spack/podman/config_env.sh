. ../sanitze_env.sh

. spack/share/spack/setup-env.sh

export SPACK_PYTHON=/glade/u/apps/opt/conda/envs/npl/bin/python3

type spack >/dev/null 2>&1 || exit 1

cat > spack.yaml <<EOF
spack:
  config:
    source_cache: /glade/scratch/${USER}/spack_caches/source
  concretizer:
    unify: false
    targets:
      granularity: generic
  compilers:
  - compiler:
      spec: gcc@11.3.0
      paths:
        cc: /glade/work/benkirk/my_spack_playground/deploy/view/CentOS-compilers/gcc/11.3.0/bin/gcc
        cxx: /glade/work/benkirk/my_spack_playground/deploy/view/CentOS-compilers/gcc/11.3.0/bin/g++
        f77: /glade/work/benkirk/my_spack_playground/deploy/view/CentOS-compilers/gcc/11.3.0/bin/gfortran
        fc: /glade/work/benkirk/my_spack_playground/deploy/view/CentOS-compilers/gcc/11.3.0/bin/gfortran
      flags:
        ldflags: -L/glade/work/benkirk/my_spack_playground/deploy/view/CentOS-compilers/gcc/11.3.0/lib64
      operating_system: centos7
      target: x86_64
      modules: []
      environment: {}
      extra_rpaths:
        - /glade/work/benkirk/my_spack_playground/deploy/view/CentOS-compilers/gcc/11.3.0/lib64

  packages:
    all:
      target: [x86_64]
EOF

spack env remove -y testenv 2>/dev/null
spack env create testenv ./spack.yaml 2>/dev/null
spack env activate testenv || exit 1

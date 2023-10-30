. ../sanitze_env.sh

. spack/share/spack/setup-env.sh

#export SPACK_PYTHON=/glade/u/apps/opt/conda/envs/npl/bin/python3
if [ -d /local_scratch/pbs.${PBS_JOBID} ]; then
    export TMPDIR=/local_scratch/pbs.${PBS_JOBID}/${USER}_spack_tmp && rm -rf ${TMPDIR} && mkdir -p ${TMPDIR}
fi
spack_build_stage_path=${TMPDIR}/stage
spack_env=testenv

echo "spack_build_stage_path=${spack_build_stage_path}"
echo "SCRATCH=${SCRATCH}"

type spack >/dev/null 2>&1 || exit 1

cat > spack.yaml <<EOF
spack:
  config:
    source_cache: ${SCRATCH}/spack_caches/source
    build_stage: ${spack_build_stage_path}
  concretizer:
    unify: false
    targets:
      granularity: generic
  packages:
    all:
      target: [x86_64]
  view:
    base:
      root: $(pwd)/${spack_env}
      projections:
        all: '{name}/{version}'
      link: roots
      link_type: symlink

EOF

# if [ -x /glade/work/benkirk/my_spack_playground/deploy/view/CentOS-compilers/gcc/11.3.0/bin/gcc ]; then
#     cat >> spack.yaml <<EOF
#   compilers:
#   - compiler:
#       spec: gcc@11.3.0
#       paths:
#         cc: /glade/work/benkirk/my_spack_playground/deploy/view/CentOS-compilers/gcc/11.3.0/bin/gcc
#         cxx: /glade/work/benkirk/my_spack_playground/deploy/view/CentOS-compilers/gcc/11.3.0/bin/g++
#         f77: /glade/work/benkirk/my_spack_playground/deploy/view/CentOS-compilers/gcc/11.3.0/bin/gfortran
#         fc: /glade/work/benkirk/my_spack_playground/deploy/view/CentOS-compilers/gcc/11.3.0/bin/gfortran
#       flags:
#         ldflags: -L/glade/work/benkirk/my_spack_playground/deploy/view/CentOS-compilers/gcc/11.3.0/lib64
#       operating_system: centos7
#       target: x86_64
#       modules: []
#       environment: {}
#       extra_rpaths:
#         - /glade/work/benkirk/my_spack_playground/deploy/view/CentOS-compilers/gcc/11.3.0/lib64

# EOF
# fi

spack env remove -y ${spack_env} 2>/dev/null
spack env create ${spack_env} ./spack.yaml 2>/dev/null
spack env activate ${spack_env} || exit 1

#!/bin/bash


topdir=$(pwd)
forge_libdir=${topdir}/install/linaro-forge/lib

rm -rf ${forge_libdir} && mkdir -p ${forge_libdir} && cd ${forge_libdir} || exit 1
module reset >/dev/null 2>&1
module load gcc/12.2.0 >/dev/null 2>&1
module unload ncarcompilers hdf5 netcdf >/dev/null 2>&1
module load linaro-forge >/dev/null 2>&1
module list

make-profiler-libraries --platform=cray --lib-type=shared

cd ${topdir}

. config_env.sh || exit 1
#module load PrgEnv-cray/8.3.3


[ -d ParallelIO ] || git clone -b bugtest/lustre https://github.com/jedwards4b/ParallelIO.git || exit 1

cd ParallelIO || exit 1

PATH=${topdir}/install/cmake/bin:${PATH}

which cmake && cmake --version || exit 1

rm -rf BUILD && mkdir BUILD && cd BUILD || exit 1

# CC=$(which cc) FC=$(which ftn) \
#   cmake -Wno-dev \
#   -DFFLAGS="-ffixed-line-length-none -ffree-line-length-none -fallow-argument-mismatch" \
#   -DFCFLAGS="-ffixed-line-length-none -ffree-line-length-none" \
#   -DNetCDF_C_PATH=${topdir}/install/netcdf \
#   -DNetCDF_Fortran_PATH=${topdir}/install/netcdf \
#   -DPnetCDF_PATH=${topdir}/install/pnetcdf \
#   -DCMAKE_INSTALL_PREFIX=${topdir}/install/pio \
#   ${topdir}/ParallelIO

CC="$(which cc)" FC="$(which ftn) -ffixed-line-length-none -ffree-line-length-none" \
  cmake -Wno-dev \
  -DNetCDF_C_PATH=${topdir}/install/netcdf \
  -DNetCDF_Fortran_PATH=${topdir}/install/netcdf \
  -DPnetCDF_PATH=${topdir}/install/pnetcdf \
  -DCMAKE_EXE_LINKER_FLAGS="-dynamic -L${forge_libdir} -lmap-sampler-pmpi -lmap-sampler -Wl,--eh-frame-hdr -Wl,-rpath=${forge_libdir} -ldl" \
  -DCMAKE_INSTALL_PREFIX=${topdir}/install/pio \
  ${topdir}/ParallelIO

make -j 12 pioperf && \
    rm -rf ${topdir}/install/pio+forge && \
    mkdir -p ${topdir}/install/pio+forge/bin && \
    cp tests/performance/pioperf ${topdir}/install/pio+forge/bin/

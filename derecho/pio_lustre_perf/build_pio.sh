#!/bin/bash

. config_env.sh || exit 1
#module load PrgEnv-cray/8.3.3

topdir=$(pwd)

[ -d ParallelIO ] || git clone -b bugfix/lustre https://github.com/jedwards4b/ParallelIO.git || exit 1

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

CC=$(which cc) FC="$(which ftn) -ffixed-line-length-none -ffree-line-length-none" \
  cmake -Wno-dev \
  -DNetCDF_C_PATH=${topdir}/install/netcdf \
  -DNetCDF_Fortran_PATH=${topdir}/install/netcdf \
  -DPnetCDF_PATH=${topdir}/install/pnetcdf \
  -DCMAKE_INSTALL_PREFIX=${topdir}/install/pio \
  ${topdir}/ParallelIO

make -j 12 pioperf && \
    rm -rf ${topdir}/install/pio && \
    mkdir -p ${topdir}/install/pio/bin && \
    cp tests/performance/pioperf ${topdir}/install/pio/bin/

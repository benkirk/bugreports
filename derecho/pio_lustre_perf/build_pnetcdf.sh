#!/bin/bash


. config_env.sh || exit 1

topdir=$(pwd)

rm -f pnetcdf*.tar.gz
wget https://parallel-netcdf.github.io/Release/pnetcdf-1.12.3.tar.gz || exit 1

rm -rf pnetcdf*/
tar zxf pnetcdf-1.12.3.tar.gz || exit 1

cd pnetcdf-1.12.3 || exit 1

mkdir BUILD && cd BUILD || exit 1

CXX=$(which CC) CC=$(which cc) FC=$(which ftn) F77=$(which ftn) \
   ../configure \
   --enable-shared \
   --prefix=${topdir}/install/pnetcdf || exit 1


make -j 12 && make install || exit 1

cd ${topdir} && rm -rf pnetcdf*/ pnetcdf*.tar.gz

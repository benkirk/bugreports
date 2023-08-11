#!/bin/bash


. config_env.sh || exit 1

topdir=$(pwd)

rm -rf hdf5*.tar.gz

wget https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.12/hdf5-1.12.2/src/hdf5-1.12.2.tar.gz

rm -rf hdf5*/
tar zxf hdf5-1.12.2.tar.gz || exit 1

cd hdf5-1.12.2 || exit 1

mkdir BUILD && cd BUILD || exit 1

CXX=$(which CC) CC=$(which cc) FC=$(which ftn) F77=$(which ftn) \
   ../configure \
   --enable-hl --disable-cxx --enable-fortran \
   --enable-parallel \
   --with-szlib=no \
   --prefix=${topdir}/install/hdf5 || exit 1


make -j 12 V=0 && make install || exit 1

cd ${topdir} && rm -rf hdf5*/ hdf5*.tar.gz

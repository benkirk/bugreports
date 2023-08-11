#!/bin/bash


. config_env.sh || exit 1

topdir=$(pwd)

rm -f netcdf*.tar.gz
wget https://downloads.unidata.ucar.edu/netcdf-c/4.9.2/netcdf-c-4.9.2.tar.gz || exit 1
wget https://downloads.unidata.ucar.edu/netcdf-fortran/4.6.1/netcdf-fortran-4.6.1.tar.gz || exit 1

rm -rf netcdf*/
tar zxf netcdf-c-4.9.2.tar.gz || exit 1
tar zxf netcdf-fortran-4.6.1.tar.gz || exit 1


cd ${topdir}/netcdf-c-4.9.2 || exit 1

mkdir BUILD && cd BUILD || exit 1

CXX=$(which CC) CC=$(which cc) FC=$(which ftn) F77=$(which ftn) \
   CPPFLAGS="-I${topdir}/install/pnetcdf/include -I${topdir}/install/hdf5/include" \
   LDFLAGS="-L${topdir}/install/pnetcdf/lib -Wl,-rpath,${topdir}/install/pnetcdf/lib -L${topdir}/install/hdf5/lib -Wl,-rpath,${topdir}/install/hdf5/lib" \
   ../configure \
   --enable-pnetcdf \
   --disable-libxml2 \
   --disable-byterange \
   --enable-hdf5 --enable-netcdf4 \
   --prefix=${topdir}/install/netcdf || exit 1


make -j 12 V=0 && make install || exit 1


cd ${topdir}/netcdf-fortran-4.6.1 || exit 1

mkdir BUILD && cd BUILD || exit 1

CXX=$(which CC) CC=$(which cc) FC=$(which ftn) F77=$(which ftn) \
   CPPFLAGS="-I${topdir}/install/netcdf/include -I${topdir}/install/pnetcdf/include -I${topdir}/install/hdf5/include" \
   LDFLAGS="-L${topdir}/install/netcdf/lib -Wl,-rpath,${topdir}/install/netcdf/lib -L${topdir}/install/pnetcdf/lib -Wl,-rpath,${topdir}/install/pnetcdf/lib -L${topdir}/install/hdf5/lib -Wl,-rpath,${topdir}/install/hdf5/lib" \
   ../configure \
   --prefix=${topdir}/install/netcdf || exit 1


make -j 12 V=0 && make install || exit 1

cd ${topdir} && rm -rf netcdf*/ netcdf*.tar.gz

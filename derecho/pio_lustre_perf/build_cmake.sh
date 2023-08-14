#!/bin/bash


. config_env.sh || exit 1

module purge && which gcc && which g++ # we want the system gcc if possible

topdir=$(pwd)

[ -x ${topdir}/install/cmake/bin/cmake ] && { echo "cmake already built..."; exit 0; }

[ -w /tmp/ ] && cd /tmp/ && pwd

rm -rf cmake*.tar.gz

wget https://github.com/Kitware/CMake/releases/download/v3.24.3/cmake-3.24.3.tar.gz || exit 1

rm -rf cmake*/
tar zxf cmake-3.24.3.tar.gz || exit 1

cd cmake-3.24.3 || exit 1

mkdir BUILD && cd BUILD || exit 1

CXX=$(which g++) CC=$(which gcc) \
   ../configure \
   --generator="Unix Makefiles" \
   --no-qt-gui \
   --prefix=${topdir}/install/cmake || exit 1


make -j 12 V=0 && make install || exit 1

cd ${topdir} && rm -rf cmake*/BUILD/ cmake*.tar.gz

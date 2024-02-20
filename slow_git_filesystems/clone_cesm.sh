#!/bin/bash

topdir=${pwd}


tmpdir=$(mktemp --directory --tmpdir=${topdir})
cd ${tmpdir} || exit 1

echo "#------------------------------------------------------------------------------"
echo "# $(date)"
echo "# $(pwd)"

sstart=$(date +%s)
echo "# --> BEGIN execution"
git clone https://github.com/escomp/cesm.git my_cesm_sandbox
cd ./my_cesm_sandbox
./manage_externals/checkout_externals

sstop=$(date +%s)
elapsed=$((${sstop} - ${sstart}))
echo "# --> END execution"
echo "# Elapsed: $(python -c "print('{:.2f}'.format(${elapsed}/60))") minutes / ${elapsed} seconds ($(hostname), $(pwd))"
echo "# $(find $(pwd) | wc -l)"
echo
echo


cd ${topdir} || exit 1
rm -rf ${tmpdir}

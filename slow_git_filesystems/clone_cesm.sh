#!/bin/bash

topdir="$(pwd)"

tmpdir=$(mktemp --directory --tmpdir=${topdir})
cd ${tmpdir} || exit 1

echo "#------------------------------------------------------------------------------"
echo "# $(date)"
echo "# $(pwd)"

sstart=$(date +%s)
echo "# --> BEGIN execution"
datestamp="$(date +%F\ %H:%M)"
git clone https://github.com/escomp/cesm.git my_cesm_sandbox
cd ./my_cesm_sandbox
./manage_externals/checkout_externals

sstop=$(date +%s)
elapsed=$((${sstop} - ${sstart}))
echo "# --> END execution"
echo "# ${datestamp} Elapsed: $(python -c "print('{:6.2f}'.format(${elapsed}/60))") minutes ($(hostname), $(pwd))"
echo "# $(find $(pwd) | wc -l)"
echo
echo

[[ ! -z "${csvfile}" ]] && echo "${datestamp},${elapsed}" >> ${csvfile}

cd ${topdir} || exit 1
rm -rf ${tmpdir}

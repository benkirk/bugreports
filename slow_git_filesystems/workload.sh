#!/bin/bash

#----------------------------------------------------------------------------
# environment & site config, if any
SCRIPTDIR="$( cd "$( dirname "$(readlink -f ${BASH_SOURCE[0]})" )" >/dev/null 2>&1 && pwd )"
. ${SCRIPTDIR}/config_tests.cfg || { echo "ERROR sourcing ${SCRIPTDIR}/config_tests.cfg"; exit 1; }
#----------------------------------------------------------------------------

topdir="$(pwd)"
tmpdir=$(mktemp --directory --tmpdir=${topdir})

echo "#------------------------------------------------------------------------------"
echo "# $(hostname): $(uptime)"
echo "# $(date)"
echo "# $(pwd)"

#------------------------------------------------------------------------------
# test #1 - git clone into current working directory/tmpir
cd ${tmpdir} || exit 1
step="clone"
csvfile="csvfile_${step}"
sstart=$(date +%s)
echo "# --> BEGIN execution (${step})"
datestamp="$(date +%F\ %H:%M)"
git clone https://github.com/escomp/cesm.git my_cesm_sandbox
cd ./my_cesm_sandbox
./manage_externals/checkout_externals
sstop=$(date +%s)
elapsed=$((${sstop} - ${sstart}))
echo "# --> END execution (${step})"
echo "# ${datestamp} Elapsed (${step}): $(python -c "print('{:6.2f}'.format(${elapsed}/60))") minutes ($(hostname), $(pwd))"
echo "# Items: $(find $(pwd) | wc -l)"
echo "# Size:  $(du -hs $(pwd))"
echo
echo
[[ -f "${!csvfile}" ]] && echo "${datestamp},${elapsed}" >> ${!csvfile}



#------------------------------------------------------------------------------
# test #2 - create uncompressed tar archive
cd ${tmpdir} || exit 1
step="tar"
csvfile="csvfile_${step}"
sstart=$(date +%s)
echo "# --> BEGIN execution (${step})"
datestamp="$(date +%F\ %H:%M)"
tar cf my_cesm_sandbox.tar my_cesm_sandbox/
ls -ltrh my_cesm_sandbox.tar
rm -f my_cesm_sandbox.tar
sstop=$(date +%s)
elapsed=$((${sstop} - ${sstart}))
echo "# --> END execution (${step})"
echo "# ${datestamp} Elapsed (${step}): $(python -c "print('{:6.2f}'.format(${elapsed}))") seconds ($(hostname), $(pwd))"
echo
echo
[[ -f "${!csvfile}" ]] && echo "${datestamp},${elapsed}" >> ${!csvfile}



#------------------------------------------------------------------------------
# test #3 - create 0-filled file from dd
step="dd"
csvfile="csvfile_${step}"
cd ${tmpdir} || exit 1
sstart=$(date +%s)
echo "# --> BEGIN execution (${step})"
datestamp="$(date +%F\ %H:%M)"
dd if=/dev/zero of=0.dat bs=1M count=24000
ls -ltrh 0.dat
rm -f 0.dat
sstop=$(date +%s)
elapsed=$((${sstop} - ${sstart}))
echo "# --> END execution (${step})"
echo "# ${datestamp} Elapsed (${step}): $(python -c "print('{:6.2f}'.format(${elapsed}))") seconds ($(hostname), $(pwd))"
echo
echo
[[ -f "${!csvfile}" ]] && echo "${datestamp},${elapsed}" >> ${!csvfile}



#------------------------------------------------------------------------------
# test #4 rsync to another tmpdir on the same file system
step="rsync"
csvfile="csvfile_${step}"
cd ${topdir} || exit 1
sstart=$(date +%s)
echo "# --> BEGIN execution (${step})"
datestamp="$(date +%F\ %H:%M)"
set -x
rsync -axAHX --info=STATS2 ${tmpdir}/ ${tmpdir}.duplicate/
set +x
sstop=$(date +%s)
elapsed=$((${sstop} - ${sstart}))
echo "# --> END execution (${step})"
echo "# ${datestamp} Elapsed (${step}): $(python -c "print('{:6.2f}'.format(${elapsed}))") seconds ($(hostname), $(pwd))"
echo
echo
[[ -f "${!csvfile}" ]] && echo "${datestamp},${elapsed}" >> ${!csvfile}



### #------------------------------------------------------------------------------
### # test #5 rsync to tmpdir on each file system
### step="rsync_pairs"
### csvfile="csvfile_${step}"
### cumulative=0
### cd ${topdir} || exit 1
### echo "# --> BEGIN execution (${step})"
###
###
### for other_dir in "${testdirs[@]}"; do
###     [ -w ${other_dir} ] || continue
###     otestdir="${other_dir}/${NCAR_HOST}"
###     mkdir -p ${otestdir}
###     otmpdir=$(mktemp --directory --tmpdir=${otestdir})
###     sstart=$(date +%s)
###     datestamp="$(date +%F\ %H:%M)"
###     set -x
###     rsync -axAHX --info=STATS2 ${tmpdir}/ ${otmpdir}/
###     rm -rf ${otmpdir}
###     set +x
###     sstop=$(date +%s)
###     elapsed=$((${sstop} - ${sstart}))
###     cumulative=$((${cumulative}+${elapsed}))
###     [[ -f "${!csvfile}" ]] && echo "${datestamp},${other_dir},${elapsed}" >> ${!csvfile}
###
### done
###
### echo "# --> END execution (${step})"
### echo "# ${datestamp} Elapsed (${step}): $(python -c "print('{:6.2f}'.format(${cumulative}))") seconds ($(hostname), $(pwd))"
### echo
### echo



#------------------------------------------------------------------------------
# test #6 du & clean up
step="cleanup"
csvfile="csvfile_${step}"
cd ${topdir} || exit 1
sstart=$(date +%s)
echo "# --> BEGIN execution (${step})"
datestamp="$(date +%F\ %H:%M)"
set -x
ls ${topdir}
echo "Items: $(find ${topdir} | wc -l)"
echo "Size:  $(du -hs ${topdir})"
rm -rf ${tmpdir} ${tmpdir}.duplicate
set +x
sstop=$(date +%s)
elapsed=$((${sstop} - ${sstart}))
echo "# --> END execution (${step})"
echo "# ${datestamp} Elapsed (${step}): $(python -c "print('{:6.2f}'.format(${elapsed}))") seconds ($(hostname), $(pwd))"
echo
echo
[[ -f "${!csvfile}" ]] && echo "${datestamp},${elapsed}" >> ${!csvfile}

#!/bin/bash

#----------------------------------------------------------------------------
# environment & site config, if any
SCRIPTDIR="$( cd "$( dirname "$(readlink -f ${BASH_SOURCE[0]})" )" >/dev/null 2>&1 && pwd )"
. ${SCRIPTDIR}/config_tests.cfg || { echo "ERROR sourcing ${SCRIPTDIR}/config_tests.cfg"; exit 1; }
#----------------------------------------------------------------------------


#--------------------------------------------------------------
LOCK="${HOME}/.fs_workload_tests_${NCAR_HOST}.lock"

remove_lock()
{
    rm -f "${LOCK}"
}

another_instance()
{
    echo "Cannot acquire lock on ${LOCK}"
    echo "There is another instance running, exiting"
    exit 1
}

# acquire an exclusive lock on our ${LOCK} file to make sure
# only one copy of this script is running at a time.
lockfile -r 5 -l $((3600*2)) "${LOCK}" || another_instance
trap remove_lock EXIT

#--------------------------------------------------------------
# logging:  Print status to standard out, and redirect also to our
# specified cron_logdir.
timestamp="$(date +%F@%H:%M)"
cron_logdir="${HOME}/.my_cron_logs/"
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
mkdir -p ${cron_logdir} || exit 1

echo -e "[${timestamp}]: Running ${0} on $(hostname)\n\tfrom $(pwd)" \
    | tee -a ${cron_logdir}/fs_workload_tests.log



#--------------------------------------------------------------
cleanup()
{
    for dir in "${testdirs[@]}"; do
        [ -w ${dir} ] || continue
        testdir="${dir}/${NCAR_HOST}"
        [ -d ${testdir} ] && rm -rf ${testdir}/*
    done
}

# start clean
cleanup

sstart=$(date +%s)
topdir="$(pwd)"
logdir="${topdir}/logs"
mkdir -p ${logdir} || exit 1

for dir in "${testdirs[@]}"; do

    testpath=${dir//\//_}
    export logfile="${logdir}/${NCAR_HOST}${testpath}.log"
    export csvfile_clone="${logdir}/${NCAR_HOST}${testpath}-GIT_CLONE.csv"
    export csvfile_tar="${logdir}/${NCAR_HOST}${testpath}-TAR.csv"
    export csvfile_dd="${logdir}/${NCAR_HOST}${testpath}-DD.csv"
    export csvfile_rsync="${logdir}/${NCAR_HOST}${testpath}-RSYNC.csv"
    export csvfile_rsync_pairs="${logdir}/${NCAR_HOST}${testpath}-RSYNC_PAIRS.csv"
    export csvfile_cleanup="${logdir}/${NCAR_HOST}${testpath}-CLEANUP.csv"

    touch "${logfile}" || { echo "Cannot write ${logfile}"; continue; }

    # initiate CSV results files
    for csvfile in ${csvfile_clone} ${csvfile_tar} ${csvfile_dd} ${csvfile_rsync} ${csvfile_cleanup}; do
        if [ ! -f "${csvfile}" ]; then
            cat <<EOF >${csvfile}
# ${NCAR_HOST} - ${dir}
Date,Elapsed(s)
EOF
        fi
    done
    if [ ! -f "${csvfile_rsync_pairs}" ]; then
            cat <<EOF >${csvfile_rsync_pairs}
# ${NCAR_HOST} - ${dir}
Date,Destdir,Elapsed(s)
EOF
        fi


    #----------------------------------------------------------
    export testdir="${dir}/${NCAR_HOST}"
    mkdir -p ${testdir} && cd ${testdir} || continue
    ${SCRIPTDIR}/workload.sh >> ${logfile} 2>&1 &

    # see how many jobs we have launched, block & wait when equal to n_concurrent
    while true; do
        n_current=$(jobs -p | wc -l)
        [ ${n_current} -lt ${n_concurrent} ] && break
        sleep 15s
    done

    cd ${topdir}
done

wait

# end clean
cleanup

#--------------------------------------------------------------
# reporting
sstop=$(date +%s)
elapsed=$((${sstop} - ${sstart}))
echo -e "\tElapsed: $(python -c "print('{:6.2f}'.format(${elapsed}/60.))") minutes" \
    | tee -a ${cron_logdir}/fs_workload_tests.log

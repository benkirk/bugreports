#!/bin/bash

#----------------------------------------------------------------------------
# environment & site config, if any
SCRIPTDIR="$( cd "$( dirname "$(readlink -f ${BASH_SOURCE[0]})" )" >/dev/null 2>&1 && pwd )"
#----------------------------------------------------------------------------


#--------------------------------------------------------------
LOCK="${HOME}/.git_clone_tests_${NCAR_HOST}.lock"

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
    | tee -a ${cron_logdir}/git_clone_tests.log




#--------------------------------------------------------------
topdir="$(pwd)"
logdir="${topdir}/logs"
mkdir -p ${logdir} || exit 1

for dir in {${HOME},${SCRATCH},${WORK},/var/tmp/${USER}}/git_clone_tests; do

    testpath=${dir//\//_}
    export logfile="${logdir}/${NCAR_HOST}${testpath}.log"
    export csvfile="${logdir}/${NCAR_HOST}${testpath}.csv"

    touch "${logfile}" || { echo "Cannot write ${logfile}"; continue; }

    if [ ! -f "${csvfile}" ]; then
        cat <<EOF >${csvfile}
# ${NCAR_HOST} - ${dir}
Date,Elapsed(s)
EOF
    fi

    #echo ${logfile}
    #echo ${testpath}

    test_dir="${dir}/${NCAR_HOST}"
    mkdir -p ${test_dir} && cd ${test_dir} || continue
    ${SCRIPTDIR}/clone_cesm.sh >> ${logfile} 2>&1 &
    sleep 15s

    cd ${topdir}
done

wait

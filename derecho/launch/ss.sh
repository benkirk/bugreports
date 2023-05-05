#!/bin/bash

logfile="ss.$(hostname).${PBS_JOBID}.out"

[ $# -eq 1 ] && logfile=$1

rm -f ${logfile}

while true ; do
    echo "# $(date)" >> ${logfile}
    ss -tlpn >> ${logfile}
    echo && echo && echo >> ${logfile}
    sleep 10s
done

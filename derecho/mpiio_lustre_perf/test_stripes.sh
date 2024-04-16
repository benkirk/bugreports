#!/bin/bash

test="pio_noncontig"
topdir=$(pwd)

. config_env.sh || exit 1
make ${test} || exit 1

mkdir -p logs/

#--------------------------------------------
# default PFL case
casedir="${topdir}/logs/default_PFL/"
echo "submitting ${casedir}"
mkdir -p ${casedir} && cd ${casedir} || exit 1

[ -f config_env.sh ] || ln -s ${topdir}/config_env.sh .
[ -f ${test}       ] || ln -s ${topdir}/${test} .

LASTID=$(qsub -A SCSG0001 -N ${test}-default_PFL ${topdir}/run.pbs)

#--------------------------------------------
# sweep over stripes
for size in 128M 064M 032M 016M 008M 004M 002M 001M; do
    for count in 02 04 06 12 24 48 96; do
        casedir="${topdir}/logs/c$(printf "%02d" ${count})_S${size}/"
        echo "submitting ${casedir}"
        mkdir -p ${casedir} && cd ${casedir} || exit 1
        stripe_cmd="lfs setstripe -c ${count} -S ${size} ."
        eval "${stripe_cmd}"

        [ -f config_env.sh ] || ln -s ${topdir}/config_env.sh .
        [ -f ${test}       ] || ln -s ${topdir}/${test} .

        LASTID=$(qsub -A SCSG0001 -N ${test}-c${count}_S${size} -W depend=afterany:${LASTID} ${topdir}/run.pbs)
    done
done

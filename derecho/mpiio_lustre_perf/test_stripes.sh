#!/bin/bash



topdir=$(pwd)

mkdir -p logs/

LASTID="none"
for size in 128M 064M 032M 016M 004M 001M; do
    for count in 02 04 06 12 24 48 96; do
        casedir="${topdir}/logs/c$(printf "%02d" ${count})_S${size}/"
        echo "submitting ${casedir}"
        mkdir -p ${casedir} && cd ${casedir} || exit 1
        stripe_cmd="lfs setstripe -c ${count} -S ${size} ."
        eval "${stripe_cmd}"

        ln -sf ${topdir}/Makefile .
        ln -sf ${topdir}/config_env.sh .

        [[ ${LASTID} == "none" ]] \
            && LASTID=$(qsub -A SCSG0001 -N pioperf-c${count}_S${size} ${topdir}/run.pbs) \
                || LASTID=$(qsub -A SCSG0001 -N pioperf-c${count}_S${size} -W depend=afterany:${LASTID} ${topdir}/run.pbs)

    done
done

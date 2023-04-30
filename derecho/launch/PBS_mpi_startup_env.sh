#!/bin/bash
#PBS -N launchtest
#PBS -A SCSG0001
#PBS -q main
#PBS -j oe
#PBS -k oed
#PBS -l walltime=00:20:00
#PBS -l select=1:ncpus=128:mpiprocs=128:mem=200G

module load crayenv/23.03 >/dev/null 2>&1
module reset >/dev/null 2>&1
module list

[[ "x${SCRATCH}" == "x" ]] && SCRATCH=/glade/derecho/scratch/${USER}

NNODES=$(cat $PBS_NODEFILE | sort | uniq | wc -l) && echo $NNODES
NRANKS=$(cat $PBS_NODEFILE | wc -l) && echo $NRANKS
PPN=$(($NRANKS/$NNODES)) && echo $PPN

mkdir -p $SCRATCH/launch_test

exec=$SCRATCH/launch_test/my_env.${NNODES}.${PPN}.${PBS_JOBID}
log=$SCRATCH//launch_test/env.${NNODES}.${PPN}.${PBS_JOBID}.out

step=0

while true ; do
    rm -f ${exec}
    cp /usr/bin/env ${exec}

    mpiexec -n $NRANKS -ppn $PPN --verbose ${exec} > ${log} 2>&1 || \
        { grep "rank" ${log} | sort | uniq; echo "FAILED at $(date)"; exit 1; }
    grep PALS ${log} | egrep -v "RANK|LOCAL|NODE" | sort | uniq

    step=$((${step}+1))
    sleep 2s && echo && echo "step ${step}" && echo

done

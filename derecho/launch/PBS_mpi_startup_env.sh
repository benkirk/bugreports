#!/bin/bash
#PBS -N launchtest
#PBS -A SCSG0001
#PBS -q main
#PBS -j oe
#PBS -k oed
#PBS -l walltime=00:10:00
#PBS -l select=1:ncpus=128:mpiprocs=128:mem=200G

module load crayenv/23.03 >/dev/null 2>&1
module reset >/dev/null 2>&1
module list

[[ "x${SCRATCH}" == "x" ]] && SCRATCH=/glade/derecho/scratch/${USER}

NNODES=$(cat $PBS_NODEFILE | sort | uniq | wc -l) && echo $NNODES
NRANKS=$(cat $PBS_NODEFILE | wc -l) && echo $NRANKS
PPN=$(($NRANKS/$NNODES)) && echo $PPN

mkdir -p $SCRATCH/launch_test/$PBS_JOBID
hw=$SCRATCH/launch_test/hw.${NNODES}.${PPN}.${PBS_JOBID}
CC ./hello_world_mpi.C -o ${hw}
exec=$SCRATCH/launch_test/my_env.${NNODES}.${PPN}.${PBS_JOBID}
log=$SCRATCH//launch_test/env.${NNODES}.${PPN}.${PBS_JOBID}.out

env | sort | uniq

echo "Nodes List="
cat ${PBS_NODEFILE} | sort | uniq

#MPIEXEC_OPTS="--verbose --restart"
MPIEXEC_OPTS="--verbose"

# for node in $(cat $PBS_NODEFILE | sort | uniq); do
#     ssh ${node} "$(pwd)/ss.sh $SCRATCH/launch_test/ss-${node}.${NNODES}.${PPN}.${PBS_JOBID}.out 2>&1" >/dev/null 2>&1 &
# done

step=0

while true ; do
    rm -f ${exec}
    cp /usr/bin/env ${exec}

    # tstart=$(date +%s)
    # mpiexec -n $NRANKS -ppn $PPN ${MPIEXEC_OPTS} ${exec} > ${log} 2>&1 || \
    #     { grep "rank" ${log} | sort | uniq; echo "FAILED at $(date)"; exit 1; }
    # #grep PALS ${log} | egrep -v "RANK|LOCAL|NODE" | sort | uniq
    # tstop=$(date +%s)
    # echo "launched ${exec} on ${NNODES} nodes / ${NRANKS} ranks ; $((${tstop}-${tstart})) elapsed seconds"


    tstart=$(date +%s)
    mpiexec -n $NRANKS -ppn $PPN ${MPIEXEC_OPTS} ${hw} > ${log}.hw 2>&1 ||
        { echo "FAILED at $(date)"; exit 1; }
    tstop=$(date +%s)
    echo "launched ${hw} on ${NNODES} nodes / ${NRANKS} ranks ; $((${tstop}-${tstart})) elapsed seconds"

    step=$((${step}+1))
    sleep 2s && echo && echo "step ${step}" && echo
done

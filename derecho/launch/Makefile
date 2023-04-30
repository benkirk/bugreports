njobs ?= 1

runmany: Makefile
	JID=$$(qsub -l select=10:ncpus=128:mpiprocs=128 -N launchtest ./PBS_mpi_startup_env.sh) ; \
	for nn in 10 50 100 200 300 400; do \
	  for jj in $$(seq 1 $(njobs)); do \
	    echo -n "submitting job #$$jj / #nodes $$nn: " ; \
	    qsub -l select=$${nn}:ncpus=128:mpiprocs=128 -N launchtest_$${nn}_step-$${jj} -W depend=afterany:$$JID ./PBS_mpi_startup_env.sh ; \
	  done ; \
	done

FORCE:

clean:
	rm -f log-* *~ launch*.o*

qdelall:
	qdel $$(qstat -u $${USER} 2>/dev/null | grep ".desched" | grep "launch" | cut -d'.' -f1)

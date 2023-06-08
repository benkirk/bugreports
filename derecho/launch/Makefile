njobs ?= 1

#	for nn in 50 100 150 200 250 300 350 400; do \

runmany:
	for nn in 2048 1024 512 256 128 64 32; do \
	  for jj in $$(seq 1 $(njobs)); do \
	    echo -n "submitting job #$$jj / #nodes $$nn: " ; \
	    qsub -l select=$${nn}:ncpus=128:mpiprocs=128 -N launchtest_$${nn}_step-$${jj} ./PBS_mpi_startup_env.sh ; \
	  done ; \
	done

clean:
	rm -f log-* *~ launch*.o*

qdelall:
	qdel $$(qstat -u $${USER} 2>/dev/null | grep ".desched" | grep "launch" | cut -d'.' -f1)

report:
	@grep "step " launchtest_* | sort | uniq
	@echo && echo && echo
	@grep FAILED launchtest* 2>/dev/null

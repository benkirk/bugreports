CXX ?= mpicxx

run:
	$(MAKE) hello_world_mpi
	qsub -A SCSG0001 test.pbs

hello_world_mpi: hello_world_mpi.C
	$(CXX) -o $@ $< -fopenmp

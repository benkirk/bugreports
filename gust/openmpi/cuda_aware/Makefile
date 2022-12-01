all: mpi_cpu_gpu_mem_options

mpi_cpu_gpu_mem_options: mpi_cpu_gpu_mem_options.C
	mpicxx -g -o mpi_cpu_gpu_mem_options mpi_cpu_gpu_mem_options.C -lcuda -lcudart

run_CPU: mpi_cpu_gpu_mem_options
	@echo "------------------"
	@echo "CPU Memory:"
	@echo "------------------"
	mpiexec $(MPI_ARGS) ./mpi_cpu_gpu_mem_options || echo "Failed"
	@echo && echo && echo

run_GPUd: mpi_cpu_gpu_mem_options
	@echo "------------------"
	@echo "GPU Device Memory:"
	@echo "------------------"
	mpiexec $(MPI_ARGS) ./mpi_cpu_gpu_mem_options -d || echo "Failed"
	@echo && echo && echo

run_GPUm: mpi_cpu_gpu_mem_options
	@echo "------------------"
	@echo "GPU Managed Memory:"
	@echo "------------------"
	mpiexec $(MPI_ARGS) ./mpi_cpu_gpu_mem_options -m || echo "Failed"
	@echo && echo && echo

run:
	$(MAKE) run
	$(MAKE) run_GPUd
	$(MAKE) run_GPUm

clean:
	rm -f *~ mpi_cpu_gpu_mem_options *.o core

clobber:
	$(MAKE) clean
	rm -f run*.sh.o*

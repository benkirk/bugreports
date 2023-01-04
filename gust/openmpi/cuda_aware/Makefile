all: hello_world_mpi_send_recv mpi_cpu_gpu_mem_options

hello_world_mpi_send_recv: hello_world_mpi_send_recv.C
	mpicxx -g -o hello_world_mpi_send_recv hello_world_mpi_send_recv.C -lcuda -lcudart

mpi_cpu_gpu_mem_options: mpi_cpu_gpu_mem_options.C
	mpicxx -g -o mpi_cpu_gpu_mem_options mpi_cpu_gpu_mem_options.C -lcuda -lcudart

run_hello: hello_world_mpi_send_recv
	@echo "----------------------------"
	@echo "Hello, World with a send/rev"
	@echo "----------------------------"
	mpiexec $(MPI_ARGS) ./hello_world_mpi_send_recv || echo "Failed"
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

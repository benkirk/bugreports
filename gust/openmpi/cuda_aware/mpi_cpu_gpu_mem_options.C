#include <iostream>
#include <iomanip>
#include <cassert>
#include <cstdio>
#include <vector>
#include <limits>
#include <unistd.h>
#include "mpi.h"
#include "cuda.h"
#include "cuda_runtime.h"


enum MemType { CPU=0, GPU, GPU_Managed };


// anonymous namespace to hold "global" variables, but restricted to this translation unit
namespace {

  int rank=-1, local_rank=-1, nranks=-1;
  char hn[256];

  int CUDA_CHECK(cudaError_t stmt)
  {
    int err_n = (int) (stmt);
    if (0 != err_n) {
      fprintf(stderr, "[%s:%d] CUDA call '%d' failed with %d: %s \n",
              __FILE__, __LINE__, stmt, err_n, cudaGetErrorString(stmt));
      exit(EXIT_FAILURE);
    }
    assert(cudaSuccess == err_n);
    return 0;
  }

}



// https://www.open-mpi.org/faq/?category=runcuda
void select_cuda_device()
{
  int num_devices = 0;

  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  MPI_Comm local_comm;
  MPI_Comm_split_type(MPI_COMM_WORLD, MPI_COMM_TYPE_SHARED, rank, MPI_INFO_NULL, &local_comm);
  MPI_Comm_rank(local_comm, &local_rank);
  MPI_Comm_free(&local_comm);

  cudaGetDeviceCount(&num_devices);
  cudaSetDevice(local_rank % num_devices);
}



template <typename T>
T* allocate(const std::size_t cnt, const MemType mem_type)
{
  T* buffer = NULL;
  if (0 == cnt) return buffer;

  switch (mem_type)
    {
    case CPU:
      buffer = (T *) malloc(cnt*sizeof(T));
      assert (NULL != buffer);
      return buffer;

    case GPU:
      CUDA_CHECK(cudaMalloc((void**) &buffer, cnt*sizeof(T)));
      return buffer;

    case GPU_Managed:
      CUDA_CHECK(cudaMallocManaged((void**) &buffer, cnt*sizeof(T)));
      return buffer;

    default:
      assert (false);
      break;
    }

  return NULL;
}



template <typename T>
int deallocate (T *buffer, const MemType mem_type)
{
  if (NULL == buffer)
    return 0;

  switch (mem_type)
    {
    case CPU:
      free(buffer);
      buffer = NULL;
      break;

    case GPU:
    case GPU_Managed:
      CUDA_CHECK(cudaFree(buffer));
      buffer = NULL;
      break;

    default:
      assert (false);
      break;
    }

  return 0;
}



int main (int argc, char **argv)
{
  // (OpenMPI previously said:) Message size 1200000000 bigger than supported by selected transport. Max = 1073741824
  const std::size_t bufcnt_MAX = 1073741824 / sizeof(int);
  int opt;
  int *buf = NULL;
  MemType mem_type = CPU;

  while((opt = getopt(argc, argv, ":dmc")) != -1)
    {
      switch(opt)
        {
	case 'd':
	  mem_type = GPU;
	  break;

	case 'm':
	  mem_type = GPU_Managed;
	  break;

	case '?':
	  printf("unknown option: %c\n", opt);
	  break;
        }
    }

  gethostname(hn, sizeof(hn) / sizeof(char));

  MPI_Init(&argc, &argv);
  MPI_Comm_size (MPI_COMM_WORLD, &nranks);
  MPI_Comm_rank (MPI_COMM_WORLD, &rank);

  if (nranks%2)
    {
      std::cerr << "ERROR: this requires an even number of ranks!\n";
      MPI_Abort(MPI_COMM_WORLD, 1);
      assert(false);
    }

  std::cout << "Hello from " << std::setw(3) << rank
            << " / " << std::string (hn)
	    << ", running " << argv[0] << " on "
	    << std::setw(3) << nranks << " ranks"
	    << std::endl;

  select_cuda_device();

  if (rank==0)
    {
      switch (mem_type)
	{
	case CPU:
	  std::cout << "Allocating CPU host memory for \"buf\"\n";
	  break;
	case GPU:
	  std::cout << "Allocating GPU device memory for \"buf\"\n";
	  break;
	case GPU_Managed:
	  std::cout << "Allocating GPU device *managed* memory for \"buf\"\n";
	}
    }


  std::vector<std::size_t> cnts{0,1};
  while (cnts.back() < bufcnt_MAX)
    {
      const std::size_t b = cnts.back();
      cnts.push_back( 3*b);
      cnts.push_back(10*b);
    }
  while (cnts.back() > bufcnt_MAX) cnts.pop_back();
  cnts.push_back(bufcnt_MAX);

  MPI_Barrier(MPI_COMM_WORLD);

  for (auto & bufcnt : cnts)
    {
      //--------------------
      buf = allocate<int>(bufcnt, mem_type);

      const double t_start = MPI_Wtime();

      if (rank%2 == 0) // even ranks send... Use 'Ssend' if you want our timing includes the matching receive.
        MPI_Send (buf, bufcnt, MPI_INT, /* dest = */ (rank + 1), /* tag = */ 100, MPI_COMM_WORLD);

      else // odd ranks recv
        MPI_Recv (buf, bufcnt, MPI_INT, /* src = */ (rank - 1), /* tag = */ 100, MPI_COMM_WORLD, MPI_STATUS_IGNORE);

      const double elapsed = MPI_Wtime() - t_start;

      if (rank == 0)
        std::cout << std::setw(10) << bufcnt << " : "
                  << std::scientific << elapsed << " (sec)"
                  << std::endl;

      deallocate(buf,  mem_type);
    }

  MPI_Finalize();

  return 0;
}

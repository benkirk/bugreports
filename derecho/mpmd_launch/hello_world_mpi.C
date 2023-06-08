#include <iostream>
#include <iomanip>
#include <omp.h>
#include <unistd.h>
#include <vector>
#include "mpi.h"



int main (int argc, char **argv)
{
  int numranks, rank, nthreads=1;
  char hn[256];

  gethostname(hn, sizeof(hn) / sizeof(char));

#pragma omp parallel
  { if (0 == omp_get_thread_num()) nthreads = omp_get_num_threads(); }


  int prov=MPI_THREAD_MULTIPLE;
  //MPI_Init_thread(&argc, &argv, MPI_THREAD_MULTIPLE, &prov);
  MPI_Init(&argc, &argv);

  MPI_Comm_size (MPI_COMM_WORLD, &numranks);
  MPI_Comm_rank (MPI_COMM_WORLD, &rank);

  MPI_Barrier(MPI_COMM_WORLD);

  std::cout << "Hello from " << std::setw(3) << rank
            << " / " << std::string (hn)
            << ", running " << argv[0] << " on "
            << std::setw(3) << numranks << " rank(s)"
            << " with " << nthreads << " threads"
            << std::endl;


  std::vector<double> v(100e6);
  std::fill(v.begin(), v.end(), 1.);

  MPI_Finalize();

  return 0;
}

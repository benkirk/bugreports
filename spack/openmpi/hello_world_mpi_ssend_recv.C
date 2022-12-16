#include <iostream>
#include <iomanip>
#include <cassert>
#include <unistd.h>
#include "mpi.h"



int main (int argc, char **argv)
{
  int numranks, rank;
  char hn[256];

  gethostname(hn, sizeof(hn) / sizeof(char));

  MPI_Init(&argc, &argv);

  MPI_Comm_size (MPI_COMM_WORLD, &numranks);
  MPI_Comm_rank (MPI_COMM_WORLD, &rank);

  assert (2 == numranks);

  std::cout << "Hello from " << rank
            << " / " << std::string (hn)
	    << ", running " << argv[0] << " on "
	    << numranks << " ranks"
	    << std::endl;

  MPI_Barrier(MPI_COMM_WORLD);

  if (0 == rank)
    {
      // First, matched send/recv
      {
        std::cout << "calling MPI_Send";
        MPI_Send (NULL, 0, MPI_INT, /* dest = */ 1, /* tag = */ 100, MPI_COMM_WORLD);
        std::cout << "...done\n";
      }

      // Next, matched isend/recv
      {
        MPI_Request req;
        std::cout << "calling MPI_Isend";
        MPI_Isend (NULL, 0, MPI_INT, /* dest = */ 1, /* tag = */ 200, MPI_COMM_WORLD, &req);
        MPI_Wait(&req, MPI_STATUS_IGNORE);
        std::cout << "...done\n";
      }

      // Next, matched ssend/recv
      {
        std::cout << "calling MPI_Ssend";
        MPI_Ssend (NULL, 0, MPI_INT, /* dest = */ 1, /* tag = */ 300, MPI_COMM_WORLD);
        std::cout << "...done\n";
      }

      // Next, matched issend/recv
      {
        MPI_Request req;
        std::cout << "calling MPI_Issend";
        MPI_Issend (NULL, 0, MPI_INT, /* dest = */ 1, /* tag = */ 400, MPI_COMM_WORLD, &req);
        MPI_Wait(&req, MPI_STATUS_IGNORE);
        std::cout << "...done\n";
      }
    }

  else
    {
      MPI_Recv (NULL, 0, MPI_INT, /* dest = */ 0, /* tag = */ 100, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
      MPI_Recv (NULL, 0, MPI_INT, /* dest = */ 0, /* tag = */ 200, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
      MPI_Recv (NULL, 0, MPI_INT, /* dest = */ 0, /* tag = */ 300, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
      MPI_Recv (NULL, 0, MPI_INT, /* dest = */ 0, /* tag = */ 400, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
    }

  MPI_Finalize();

  return 0;
}

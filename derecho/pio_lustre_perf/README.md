# ParallelIO / Cray-MPICH / Lustre Stripe Size Sensitivity

We are seeing an extreme sensitivity to lustre stripe size for a particular MPI-IO file access pattern, as implemented through the ParallelIO->NetCDF->PNetCDF->MPI-IO stack of libraries.  This has been demonstrated on two different systems, Derecho at NCAR and Perlmutter at NERSC. For smaller stripe sizes, and excessive amout of time is spent within `MPI_File_write_at_all`, with no further granularity presently available.

## Building a Replication Case

The smallest demonstration case to date requires 16 128-core nodes (2,048 MPI ranks) and access to a Lustre filesystem.  The software stack is fairly complex, but can be build on top of a base Cray environment using the scripts provided in [this repo](https://github.com/benkirk/bugreports/tree/main), or in .  Running `make all` in the `derecho/pio_lustre_perf` subdirectory performs the follwing:
* Sources a common Cray environment module set using `config_env.sh`. Currently tested with the following module stack:
  ```
  Currently Loaded Modules:
  1) crayenv/23.03   (H,S)   4) cray-pals/1.2.11     7) craype-network-ofi   10) cray-dsmml/0.2.2  
  2) cray-pmi/6.1.10         5) craype-x86-milan     8) gcc/12.2.0           11) cray-mpich/8.1.25
  3) PrgEnv-gnu/8.3.3        6) libfabric/1.15.2.0   9) craype/2.7.20
  ```
* Builds `cmake`,
* Builds `pnetcdf`,
* Builds `hdf5`,
* Builds `netcdf-c` and `netcdf-fortran`,
* Builds `ParallelIO` using all the abode dependencies.

A sample runscript is also included in `runme.sh` for PBS queueing environments.  The resulting executable, `install/pio/bin/pioperf`, can be run directly with no command line arguments required.  The standard output includes 2 lines labeled `RESULT`, each corresponding to a different parallel, 19GB file write.  For example, 
```
$ grep RESULT ./logs/c48_S{001M,128M}/pioperf-*.o*

./logs/c48_S001M/pioperf-c48_S001M.o1256835:  RESULT: ...     4303.46        4.31
./logs/c48_S001M/pioperf-c48_S001M.o1256835:  RESULT: ...       97.91      189.55

./logs/c48_S128M/pioperf-c48_S128M.o1256800:  RESULT: ...     4214.05        4.40
./logs/c48_S128M/pioperf-c48_S128M.o1256800:  RESULT: ...     2785.99        6.66
```

The first case writes decomposed variables with record dimension, the second adds a single addtional variable `char rundate(strlen)` ; where `strlen=13`.  The last two real numbers on each line are the write bandwidth and time, respectively.  Both writes slow with smaller stripe size, but the second one very dramatically: a factor of ~30X between 1MB and 128MB stripe sizes as shown in the example output above (2785.99/97.91).

## Observations 

The test case performance has been compared on IBM Spectrum Scale (GPFS) and Lustre 2.15 (Cray E1000) fileystems. In the case of Lustre, parametric sweeps of stripe size and count have been performed, and an extreme sensitivity to stripe size has been observed (performance variations of >30X).  Further, the GPFS performance is typically 1.2-1.5X better than even the best Lustre results. 

Profiling results (shown below) indicate that the smaller the Lustre stripe size, the more time is spent in `MPI_File_write_at_all`, called from `ncmpio_read_write`.  No unusual sensitivity to stripe count has been observed. Unfortunately, all profiling steps executed to date become "opaque" at the `MPI_File_write_at_all` when run under Cray-MPICH, so the source of this slowdown is still elusive.

### Profiling Results
#### GPFS

![gpfs](https://github.com/benkirk/bugreports/assets/2366572/4d83b8de-d0c1-4945-a1d5-63e5ed07095f)

#### Lustre, 48X 128MB Stripes

![lustre-48-128M](https://github.com/benkirk/bugreports/assets/2366572/9942ff52-631f-4a25-bf92-d01b623960a5)


#### Lustre, 48X 1MB Stripes

![lustre-48-1M](https://github.com/benkirk/bugreports/assets/2366572/3dc47e84-def3-4e3a-adf3-583b24bda22c)

# ParallelIO / Cray-MPICH / Lustre Stripe Size Sensitivity

We are seeing an extreme sensitivity to lustre stripe size for a particular MPI-IO file access pattern, as implemented through the ParallelIO->NetCDF->PNetCDF->MPI-IO stack of libraries.  This has been demonstrated on two different systems, Derecho at NCAR and Perlutter at NERSC.

## Building a Replication Case

The smallest demonstration case to date requires 16 128-core nodes (2,048 MPI ranks) and access to a Lustre filesystem.  The software stack is fairly complex, but can be build on top of a base Cray environment using the scripts provided in [this repo](https://github.com/benkirk/bugreports/derecho/pio_lustre_perf).  Running `make all` in the `derecho/pio_lustre_perf` subdirectory performs the follwing:
* Sources a common Cray environment module set using `config_env.sh`,
* Builds `cmake`,
* Builds `pnetcdf`,
* Builds `hdf5`,
* Builds `netcdf-c` and `netcdf-fortran`,
* Builds `ParallelIO` using all the abode dependencies.

A sample runscript is also included in `runme.sh` for PBS queueing environments.

## Observations 

The test case performance has been compared on IBM Spectrum Scale (GPFS) and Lustre 2.15 (Cray E1000) fileystems. In the case of Lustre, parametric sweeps of stripe size and count have been performed, and an extreme sensitivity to stripe size has been observed (performance variations of >30X).  Further, the GPFS performance is typically 1.2-1.5X better than even the best Lustre results.

### Profiling Results
#### GPFS

![gpfs](https://github.com/benkirk/bugreports/assets/2366572/4d83b8de-d0c1-4945-a1d5-63e5ed07095f)

#### Lustre, 48X 128MB Stripes

![lustre-48-128M](https://github.com/benkirk/bugreports/assets/2366572/9942ff52-631f-4a25-bf92-d01b623960a5)


#### Lustre, 48X 1MB Stripes

![lustre-48-1M](https://github.com/benkirk/bugreports/assets/2366572/3dc47e84-def3-4e3a-adf3-583b24bda22c)

#!/bin/bash


# if we have a module command, load the nvhpc compilers
module --config >/dev/null 2>&1 && module purge && module load nvhpc

# simple hello world sanity check
set -x
gcc  -c -g          ./hello_world.c && echo "Success!" || echo "FAIL!!!"
nvc  -v -c -g       ./hello_world.c && echo "Success!" || echo "FAIL!!!"
nvcc -v -c -g       ./hello_world.c && echo "Success!" || echo "FAIL!!!"
nvc++ -v -x c -c -g ./hello_world.c && echo "Success!" || echo "FAIL!!!"

# problem code:
gcc     -I. -c -g ./odf_init.c       && echo "Success!" || echo "FAIL!!!"
nvc  -v -I. -c -g ./odf_init.c       && echo "Success!" || echo "FAIL!!!"
nvcc -v -I. -c -g ./odf_init.c       && echo "Success!" || echo "FAIL!!!"
nvc++ -v -x c -I. -c -g ./odf_init.c && echo "Success!" || echo "FAIL!!!"
set +x


# other compilers...
## Intel OneAPI
type module >/dev/null 2>&1 && module load oneapi
set -x
icx     -I. -c -g ./odf_init.c       && echo "Success!" || echo "FAIL!!!"
set +x

## Cray CPE
type module >/dev/null 2>&1 && module load cce
set -x
cc     -I. -c -g ./odf_init.c       && echo "Success!" || echo "FAIL!!!"
set +x

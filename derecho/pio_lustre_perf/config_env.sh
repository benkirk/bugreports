#!/bin/bash

module load crayenv/23.03 >/dev/null 2>&1
module reset >/dev/null 2>&1
module load PrgEnv-gnu/8.3.3 >/dev/null 2>&1
module unload cray-libsci >/dev/null 2>&1
module list

which cc && cc --version

topdir=$(pwd)

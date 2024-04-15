#!/bin/bash

#module load crayenv/23.12 >/dev/null 2>&1
#module reset >/dev/null 2>&1
#module load PrgEnv-gnu/8.4.0 >/dev/null 2>&1
#module load perftools-base perftools >/dev/null 2>&1
#module unload cray-libsci >/dev/null 2>&1
module list


which cc && cc --version

topdir=$(pwd)

export TMPDIR=/glade/derecho/scratch/$USER/temp && mkdir -p $TMPDIR

module purge >/dev/null 2>&1
module load intel cray-mpich linaro-forge
module list

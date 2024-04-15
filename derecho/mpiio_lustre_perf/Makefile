all: pio_noncontig buf_noncontig

pio_noncontig: Makefile config_env.sh
	rm -f $@ $@.c
	wget https://raw.githubusercontent.com/wkliao/mpich/romio_dev/src/mpi/romio/test/pio_noncontig.c
	cc -o $@ $@.c

buf_noncontig: Makefile config_env.sh
	rm -f $@ $@.c
	wget https://raw.githubusercontent.com/wkliao/mpich/romio_dev/src/mpi/romio/test/buf_noncontig.c
	cc -o $@ $@.c

clean:
	rm -f *~ *.tar.*
	rm -rf */BUILD/

clobber:
	$(MAKE) clean
	rm -f ./.*stamp

distclean:
	git clean -xdf .

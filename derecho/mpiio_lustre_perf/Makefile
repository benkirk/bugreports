all: pio_noncontig buf_noncontig

%: config_env.sh
	rm -f $@ $@.c
	wget https://raw.githubusercontent.com/wkliao/mpich/romio_dev/src/mpi/romio/test/$*.c
	cc -o $@ $@.c
	rm -f $@.c

clean:
	rm -f *~ *.tar.*
	rm -rf */BUILD/

clobber:
	$(MAKE) clean
	rm -f ./.*stamp

distclean:
	git clean -xdf .

report:
	$(MAKE) report_write
	echo
	$(MAKE) report_read

report_%:
	grep "Time of collective $*" logs/*/pio_noncontig-*_*.o*

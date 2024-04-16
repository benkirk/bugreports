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
	@for file in logs/*/pio_noncontig-*_*.o*; do\
	        grep -c "Time of collective" >/dev/null $$file || continue;\
		echo "$$file : $$(grep "Time of collective $*" $$file | head -n 1) (-g 16)";\
		echo "$$file : $$(grep "Time of collective $*" $$file | tail -n 1) (-g 0)";\
	done

run: test_stripes.sh
	./$<

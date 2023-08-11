all: pio

deps: .depstamp
pio: .piostamp
pio-forge: .pioforgestamp

.piostamp: .depstamp build_pio.sh config_env.sh
	./build_pio.sh
	date > .piostamp

.pioforgestamp: .depstamp build_pio+forge.sh config_env.sh
	./build_pio+forge.sh
	date > .pioforgestamp

.depstamp: build_cmake.sh build_pnetcdf.sh build_hdf5.sh build_netcdf.sh config_env.sh
	./build_cmake.sh
	./build_pnetcdf.sh
	./build_hdf5.sh
	./build_netcdf.sh
	date > .depstamp

clean:
	rm -f *~ *.tar.*
	rm -rf */BUILD/

clobber:
	$(MAKE) clean
	rm -f ./.*stamp


distclean:
	git clean -xdf .

dist:
	cd .. && tar zcvf pio_lustre_perf/pio_lustre_perf.tar.gz pio_lustre_perf/{Makefile,*.sh}

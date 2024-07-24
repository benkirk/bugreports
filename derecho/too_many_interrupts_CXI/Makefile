SHELL := /bin/bash

.sampler_libs.stamp: config_env.sh
	@rm -f libmap-sampler*
	source config_env.sh 2>/dev/null && make-profiler-libraries --platform=cray --lib-type=shared
	@ls -l libmap-sampler* > $@

%-noprofile: %_avg.C config_env.sh
	source config_env.sh 2>/dev/null && mpicxx -O3 -g -o $@ $<

%-profile: %_avg.C .sampler_libs.stamp config_env.sh
	source config_env.sh 2>/dev/null && mpicxx -O3 -g -L$$(pwd) -lmap-sampler-pmpi -lmap-sampler -Wl,--eh-frame-hdr -Wl,-rpath=$$(pwd) -o $@ $<

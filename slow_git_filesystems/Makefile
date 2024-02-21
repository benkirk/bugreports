.PHONY: user_list.txt

plots: plot.py fonts
	./$< 1>/dev/null

fonts: Makefile
	mkdir -p $@/
	rm -f $/*.ttf
	wget https://github.com/google/fonts/raw/main/ofl/poppins/Poppins-Regular.ttf
	wget https://github.com/google/fonts/raw/main/ofl/cormorantgaramond/CormorantGaramond-Regular.ttf
	mv *.ttf $@/

clean:
	git clean -xdf --exclude "logs/"

sync:
	rsync -axv derecho:/glade/work/benkirk/bugreports/slow_git_filesystems/logs/ ./logs/

%.py : %.ipynb Makefile
	jupyter nbconvert --clear-output $<
	jupyter nbconvert --to=python $< >/dev/null
	chmod +x $@
	git add $@ $<

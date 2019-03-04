srcdir = @srcdir@

.PHONY: default
default: all


# TODO autoconf may require gnu11 or C11
# and it will generate the right flags
WRITELONG_CFLAGS = -std=gnu11 -Wall -Wextra -Werror -pedantic

writelong: $(srcdir)/writelong.c
	gcc $(WRITELONG_CFLAGS) $< -o  $@

Opts.pm: $(srcdir)/RV_Kcc/Opts.pm $(srcdir)/getopt.pl
	@mkdir -p RV_Kcc
	cat $< | perl $(srcdir)/getopt.pl > $@

kcc.trace: $(srcdir)/kcc.pl $(MODULES)
	@echo Path: $$PATH
	fatpack trace --to=$@ $(srcdir)/kcc.pl

kcc.packages: kcc.trace
	export PERL5LIB=$(CURDIR):$$PERL5LIB && fatpack packlists-for `cat $<` > $@

kcc: kcc.packages writelong Opts.pm $(srcdir)/RV_Kcc/Files.pm $(srcdir)/RV_Kcc/Shell.pm
	@echo Fatpacking kcc
	@echo `cat kcc.packages`
	fatpack tree `cat kcc.packages`
	mkdir -p fatlib/RV_Kcc
	cp Opts.pm fatlib/RV_Kcc
	cp $(srcdir)/RV_Kcc/Files.pm fatlib/RV_Kcc
	cp $(srcdir)/RV_Kcc/Shell.pm fatlib/RV_Kcc
	cp -rf RV_Kcc fatlib
	fatpack file $(srcdir)/kcc.pl > $@
	chmod --reference=$(srcdir)/kcc.pl $@

.PHONY: all
all: kcc

# So, for every Makefile we should have one `make.sh` script
# that will prepare the environment and then run `make`.

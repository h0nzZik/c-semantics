SHELL = /bin/sh
srcdir = @srcdir@

.PHONY: default
default: kcc


# TODO autoconf may require gnu11 or C11
# and it will generate the right flags
WRITELONG_CFLAGS = -std=gnu11 -Wall -Wextra -Werror -pedantic

writelong: $(srcdir)/writelong.c
	gcc $(WRITELONG_CFLAGS) $< -o  $@

RV_Kcc/Opts.pm: $(srcdir)/RV_Kcc/Opts.pm $(srcdir)/getopt.pl
	@mkdir -p $(dir $@)
	cat $< | perl $(srcdir)/getopt.pl > $@

RV_Kcc/Files.pm RV_Kcc/Shell.pm: RV_Kcc/%: $(srcdir)/RV_Kcc/%
	@mkdir -p $(dir $@)
	@cp $^ $@

RV_Kcc: | $(addprefix RV_Kcc/,Opts.pm Files.pm Shell.pm)

MODULES = Opts.pm Files.pm Shell.pm

kcc.trace: $(srcdir)/kcc.pl $(addprefix RV_Kcc/, $(MODULES))
	fatpack trace --to=$@ $(srcdir)/kcc.pl

kcc.packages: kcc.trace
	export PERL5LIB=$(dir $@):$$PERL5LIB && fatpack packlists-for `cat $<` > $@

kcc: kcc.packages writelong #RV_Kcc
	@echo Fatpacking kcc
	fatpack tree $(shell cat $<)
	cp -rf RV_Kcc fatlib
	fatpack file $(srcdir)/kcc.pl > $@
	chmod --reference=$(srcdir)/kcc.pl $@

#########################
###### Distribution #####
#########################
#
#FILES_TO_DIST = ignored-flags merge-kcc-obj gccsymdump globalize-syms make-symbols make-trampolines split-kcc-obj program-runner
#
#
#
#DIST_DIR = $(abspath $(BUILD_ROOT)/kcc/dist)
#
#DIST_DIR_FILES = $(addprefix $(DIST_DIR)/,$(FILES_TO_DIST))
#
#$(DIST_DIR)/writelong: $(DIST_DIR)/%: %
#	@$(GENERATING)
#	@cp $^ $@
#
#$(DIST_DIR_FILES): $(DIST_DIR)/%: $(srcdir)/%
#	@$(GENERATING)
#	@cp $^ $@
#
#$(DIST_DIR): | $(DIST_DIR_FILES) $(DIST_DIR)/writelong
#
#$(DIST_DIR)/kcc: kcc | $(DIST_DIR)
#	@$(GENERATING)
#	@cp $< $@
#

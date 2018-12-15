include ../inc.mk

FATPACK := $(BUILD_LOCAL_PERL)/bin/fatpack

.PHONY: default
default: dist

.PHONY: help
help:
	@echo 'Targets: default help build dist'

.PHONY: build
build: $(B)/kcc

.PHONY: dist
dist: $(DIST_ROOT)/kcc

CFLAGS := -std=gnu11 -Wall -Wextra -Werror -pedantic

$(B)/writelong: writelong.c
	@$(GENERATING)
	@mkdir -p $(dir $@)
	@gcc $(CFLAGS) $< -o  $@

$(B)/RV_Kcc/Opts.pm: RV_Kcc/Opts.pm getopt.pl
	@$(GENERATING)
	@mkdir -p $(dir $@)
	@cat $< | perl getopt.pl > $@

$(B)/RV_Kcc/Files.pm $(B)/RV_Kcc/Shell.pm: $(B)/RV_Kcc/%: RV_Kcc/%
	@$(GENERATING)
	@mkdir -p $(dir $@)
	@cp $^ $@

$(B)/RV_Kcc: $(addprefix $(B)/RV_Kcc/,Opts.pm Files.pm Shell.pm)

KCC_MODULES := $(addprefix RV_Kcc/,Opts.pm Files.pm Shell.pm)

$(B)/kcc.trace: kcc $(B)/RV_Kcc # $(KCC_MODULES) # $(B)/RV_Kcc/Opts.pm
	@$(GENERATING)
	@echo Tracing...
	@$(FATPACK) trace --to=$@ --use=RV_Kcc/Files.pm kcc

$(B)/kcc.packages: $(B)/kcc.trace
	@$(GENERATING)
	@$(FATPACK) packlists-for `cat $<` > $@

$(B)/kcc: $(B)/kcc.packages $(B)/writelong $(B)/RV_Kcc
	@$(GENERATING)
	$(eval KCC_SRC := $(shell pwd)/kcc)
	@echo KCC_SRC: $(KCC_SRC)
	@cd $(dir $@) && $(FATPACK) tree $(shell cat $(B)/kcc.packages)
	@cp -rf $(B)/RV_Kcc $(B)/fatlib
	@cd $(dir $@) && $(FATPACK) file $(KCC_SRC) > $@
	@chmod --reference=$(KCC_SRC) $@


$(DIST_ROOT)/kcc: $(B)/kcc
	@$(GENERATING)
	@mkdir -p $(dir $@)
	@cp $(B)/kcc $@

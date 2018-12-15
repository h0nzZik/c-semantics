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
	@echo Generating $(@:$(BUILD_ROOT)/%=%)
	@mkdir -p $(dir $@)
	@gcc $(CFLAGS) $< -o  $@

$(B)/RV_Kcc/Opts.pm: RV_Kcc/Opts.pm getopt.pl
	@echo Generating $(@:$(BUILD_ROOT)/%=%)
	@mkdir -p $(dir $@)
	@cat $< | perl getopt.pl > $@

$(B)/RV_Kcc/Files.pm $(B)/RV_Kcc/Shell.pm: $(B)/RV_Kcc/%: RV_Kcc/%
	@mkdir -p $(dir $@)
	@cp $^ $@

$(B)/RV_Kcc: $(addprefix $(B)/RV_Kcc/,Opts.pm Files.pm Shell.pm)

KCC_MODULES := $(addprefix RV_Kcc/,Opts.pm Files.pm Shell.pm)

$(B)/kcc.trace: kcc $(B)/RV_Kcc # $(KCC_MODULES) # $(B)/RV_Kcc/Opts.pm
	@echo Generating $(@:$(BUILD_ROOT)/%=%)
	@echo Tracing...
	@$(FATPACK) trace --to=$@ --use=RV_Kcc/Files.pm kcc

$(B)/kcc.packages: $(B)/kcc.trace
	@echo Generating $(@:$(BUILD_ROOT)/%=%)
	@$(FATPACK) packlists-for `cat $<` > $@

$(B)/kcc: $(B)/kcc.packages $(B)/writelong $(B)/RV_Kcc
	@echo Generating $(@:$(BUILD_ROOT)/%=%)
	$(eval KCC_SRC := $(shell pwd)/kcc)
	@echo KCC_SRC: $(KCC_SRC)
	@cd $(dir $@) && $(FATPACK) tree $(shell cat $(B)/kcc.packages)
	@cp -rf $(B)/RV_Kcc $(B)/fatlib
	@cd $(dir $@) && $(FATPACK) file $(KCC_SRC) > $@
	@chmod --reference=$(KCC_SRC) $@


$(DIST_ROOT)/kcc: $(B)/kcc
	@echo Generating $(@:$(BUILD_ROOT)/%=%)
	@mkdir -p $(dir $@)
	@cp $(B)/kcc $@


#$(B)/kcc: $(PERL_MODULES) $(B)/writelong $(FILES_TO_DIST)
#	mkdir -p $(B)/RV_Kcc
#	cp -RLp $(FILES_TO_DIST) $(B)
#	cp -RLp $(PERL_MODULES) $(B)/RV_Kcc
#	cp -p $(B)/kcc $(B)/kclang
#
#.PHONY: pack
#pack: $(B)/kcc
#	cd $(B) && fatpack trace kcc
#	cd $(B) && fatpack packlists-for `cat fatpacker.trace` >packlists
#	cat $(B)/packlists
#	cd $(B) && fatpack tree `cat packlists`
#	cp -rf $(B)/RV_Kcc $(B)/fatlib
#	cd $(B) && fatpack file kcc > kcc.packed
#	chmod --reference=$(B)/kcc $(B)/kcc.packed
#	mv -f $(B)/kcc.packed $(B)/kcc
#	cp -pf $(B)/kcc $(B)/kclang
#	rm -rf $(B)/fatlib $(B)/RV_Kcc $(B)/packlists $(B)/fatpacker.trace
#

ifeq ($(strip $(BUILD_DIR)),)
  $(error Need BUILD_DIR)
endif
B := $(BUILD_DIR)

default: $(B)/kcc

CFLAGS := -std=gnu11 -Wall -Wextra -Werror -pedantic

$(B)/writelong: writelong.c
	@echo Generating $(@:$(BUILD_ROOT)/%=%)
	@mkdir -p $(dir $@)
	@gcc $(CFLAGS) $< -o  $@

$(B)/RV_Kcc/Opts.pm: RV_Kcc/Opts.pm getopt.pl
	@echo Generating $(@:$(BUILD_ROOT)/%=%)
	@mkdir -p $(dir $@)
	@cat $< | perl getopt.pl > $@

PERL_MODULES = $(addprefix RV_Kcc/,Opts.pm Files.pm Shell.pm)

#TODO
$(B)/kcc.trace: kcc $(PERL_MODULES) $(B)/RV_Kcc/Opts.pm
	@echo Generating $(@:$(BUILD_ROOT)/%=%)
	@echo Tracing...
	fatpack trace --to=$@ $<

$(B)/kcc.packages: $(B)/kcc.trace
	fatpack packlists-for `cat $<`

$(B)/kcc: $(B)/writelong $(B)/kcc.packages
	@echo Generating $(@:$(BUILD_ROOT)/%=%)
	@echo No way.

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

#TODO do not rely on GCC

ifeq ($(strip $(BUILD_DIR)),)
  $(error Need BUILD_DIR)
endif

B := $(BUILD_DIR)/kcc

CFLAGS := -std=gnu11 -Wall -Wextra -Werror -pedantic

$(B)/writelong: writelong.c
	@mkdir -p $(dir $@)
	@gcc $(CFLAGS) $< -o  $@

$(B)/RV_Kcc/Opts.pm: RV_Kcc/Opts.pm getopt.pl
	@mkdir -p $(dir $@)
	@cat $< | perl getopt.pl > $@

PERL_MODULES = $(addprefix kcc/RV_Kcc/,Opts.pm Files.pm Shell.pm)

$(B)/kcc: $(PERL_MODULES) $(B)/writelong $(FILES_TO_DIST)
	mkdir -p $(B)/RV_Kcc
	cp -RLp $(FILES_TO_DIST) $(B)
	cp -RLp $(PERL_MODULES) $(B)/RV_Kcc
	cp -p $(B)/kcc $(B)/kclang

.PHONY: pack
pack: $(B)/kcc
	cd $(B) && fatpack trace kcc
	cd $(B) && fatpack packlists-for `cat fatpacker.trace` >packlists
	cat $(B)/packlists
	cd $(B) && fatpack tree `cat packlists`
	cp -rf $(B)/RV_Kcc $(B)/fatlib
	cd $(B) && fatpack file kcc > kcc.packed
	chmod --reference=$(B)/kcc $(B)/kcc.packed
	mv -f $(B)/kcc.packed $(B)/kcc
	cp -pf $(B)/kcc $(B)/kclang
	rm -rf $(B)/fatlib $(B)/RV_Kcc $(B)/packlists $(B)/fatpacker.trace


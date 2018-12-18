# imports:
# - BUILD_ROOT
# exports:
# - KCC

KCC_SRC_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
KCC_BUILD_DIR := $(abspath $(BUILD_ROOT)/kcc/build)
KCC_DIST_DIR := $(abspath $(BUILD_ROOT)/kcc/dist)

B := $(KCC_BUILD_DIR)
S := $(KCC_SRC_DIR)

#TODO make this a 'real' dependency
FATPACK := $(BUILD_LOCAL_PERL)/bin/fatpack

KCC_WRITELONG_CFLAGS := -std=gnu11 -Wall -Wextra -Werror -pedantic

$(B)/writelong: $(S)/writelong.c
	@$(GENERATING)
	@gcc $(KCC_WRITELONG_CFLAGS) $< -o  $@

$(B)/RV_Kcc/Opts.pm: $(S)/RV_Kcc/Opts.pm $(S)/getopt.pl
	@$(GENERATING)
	@cat $< | perl $(KCC_SRC_DIR)/getopt.pl > $@

$(B)/RV_Kcc/Files.pm $(B)/RV_Kcc/Shell.pm: $(B)/RV_Kcc/%: $(S)/RV_Kcc/%
	@$(GENERATING)
	@cp $^ $@

$(B)/RV_Kcc: | $(addprefix $(B)/RV_Kcc/,Opts.pm Files.pm Shell.pm)

KCC_MODULES := Opts.pm Files.pm Shell.pm

$(B)/kcc.trace: $(S)/kcc $(addprefix $(B)/RV_Kcc/, $(KCC_MODULES))
	@$(GENERATING)
	@$(FATPACK) trace --to=$@ $(KCC_SRC_DIR)/kcc

$(B)/kcc.packages: $(B)/kcc.trace
	@$(GENERATING)
	@export PERL5LIB=$(dir $@):$$PERL5LIB && $(FATPACK) packlists-for `cat $<` > $@

$(B)/kcc: $(B)/kcc.packages $(B)/writelong $(B)/RV_Kcc
	@$(GENERATING)
	@cd $(dir $@) && $(FATPACK) tree $(shell cat $<)
	@cp -rf $(KCC_BUILD_DIR)/RV_Kcc $(KCC_BUILD_DIR)/fatlib
	@cd $(dir $@) && $(FATPACK) file $(KCC_SRC_DIR)/kcc > $@
	@chmod --reference=$(KCC_SRC_DIR)/kcc $@

########################
##### Distribution #####
########################

KCC_FILES_TO_DIST := ignored-flags merge-kcc-obj gccsymdump globalize-syms make-symbols make-trampolines split-kcc-obj program-runner
KCC_DIST_DIR_FILES := $(addprefix $(KCC_DIST_DIR)/,$(KCC_FILES_TO_DIST))

$(KCC_DIST_DIR)/writelong: $(KCC_DIST_DIR)/%: $(B)/%
	@$(GENERATING)
	@cp $^ $@

$(KCC_DIST_DIR_FILES): $(KCC_DIST_DIR)/%: $(S)/%
	@$(GENERATING)
	@cp $^ $@

$(KCC_DIST_DIR): | $(KCC_DIST_DIR_FILES) $(KCC_DIST_DIR)/writelong

$(KCC_DIST_DIR)/kcc: $(KCC_BUILD_DIR)/kcc | $(KCC_DIST_DIR)
	@$(GENERATING)
	@cp $< $@

# Exports
KCC := $(KCC_DIST_DIR)/kcc

# Clean private variables
undefine B
undefine S
undefine KCC_MODULES

THIS_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

include inc.mk

ifeq ($(strip $(PROFILES_DIR)),)
  PROFILES_DIR := $(abspath $(THIS_DIR)/profiles)
endif

ifeq ($(strip $(PROFILE)),)
  PROFILES := x86-gcc-limited-libc
endif

# clang-tools, cparser, and kcc are profile-independent.
# native-server, semantics, and library depend on chosen profile
SRCS := clang-tools cparser kcc native-server semantics

# TODO make kcc depend on clang-tools and cparser,
# and make it one target

.PHONY: test
test: $(addsuffix /all,$(PROFILES))

.PHONY: default
default: clang-tools cparser kcc $(addsuffix /all,$(PROFILES))

.PHONY: help
help:
	@echo 'Targets: $(SRCS)'
	@echo 'Varibles:'
	@echo 'PROFILES_DIR := $(PROFILES_DIR)'

.PHONY: $(SRCS)
$(SRCS):
	@echo "< Building project '$@'>"
	@mkdir -p $(B)/$@
	@$(MAKE) -C $@ BUILD_DIR=$(B)/$@
	@echo "</Building project '$@'>"


.PHONY: dist-kcc
dist-kcc: clang-tools cparser kcc

#.PHONY: $(addsuffix /all,$(PROFILES))
$(addsuffix /all,$(PROFILES)): %/all: %/native-server %/semantics %/library ;

#.PHONY: $(addsuffix /native-server,$(PROFILES))
$(addsuffix /native-server,$(PROFILES)): %/native-server:
	@$(ECHO_OPEN)
	@mkdir -p $(B)/$@
	@$(MAKE) -C native-server PROFILE=$* PROFILE_DIR=$(PROFILES_DIR)/$* BUILD_DIR=$(B)/$@
	@$(ECHO_CLOSE)

#.PHONY: $(addsuffix /native-server,$(PROFILES))
$(addsuffix /semantics,$(PROFILES)): %/semantics:
	@$(ECHO_OPEN)
	@mkdir -p $(B)/$@
	@$(MAKE) -C semantics PROFILE=$* PROFILE_DIR=$(PROFILES_DIR)/$* BUILD_DIR=$(B)/$@
	@$(ECHO_CLOSE)

#.PHONY: $(addsuffix /native-server,$(PROFILES))
$(addsuffix /library,$(PROFILES)): %/library: dist-kcc
	@$(ECHO_OPEN)
	@mkdir -p $(B)/$@
	@$(ECHO_CLOSE)

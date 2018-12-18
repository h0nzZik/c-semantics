THIS_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

include inc.mk

# List of all targets I really want to build.

ifeq ($(strip $(PROFILES_DIR)),)
  PROFILES_DIR := $(abspath $(THIS_DIR)/profiles)
endif

ifeq ($(strip $(PROFILE)),)
  PROFILES := x86-gcc-limited-libc
endif

# clang-tools, cparser, and kcc are profile-independent.
# native-server, semantics, and library depend on chosen profile
SRCS := cparser kcc native-server semantics


.PHONY: default
default: $(CLANG_KAST)

include clang-tools/Makefile
B := $(BUILD_DIR) # to reset it again

.PHONY: test
test: $(addsuffix /all,$(PROFILES))

#.PHONY: default
#default: cparser kcc $(addsuffix /all,$(PROFILES))

.PHONY: help
help:
	@echo 'Targets: $(SRCS)'
	@echo 'Varibles:'
	@echo 'PROFILES_DIR := $(PROFILES_DIR)'

.PHONY: $(SRCS)
$(SRCS):
	@echo "< Building project '$@'>"
	@mkdir -p $(BUILD_DIR)/$@
	@$(MAKE) -C $@ BUILD_DIR=$(BUILD_DIR)/$@
	@echo "</Building project '$@'>"


.PHONY: dist-kcc
dist-kcc: cparser kcc

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
	$(eval PROFILE := $*)
	$(eval KCC := $(DIST_ROOT)/kcc)
	@$(MAKE) -C library KCC=$(KCC) PROFILE=$(PROFILE) PROFILE_DIR=$(PROFILES_DIR)/$(PROFILE) BUILD_DIR=$(B)/$@
	@$(ECHO_CLOSE)

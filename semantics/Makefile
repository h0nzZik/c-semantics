include $(dir $(lastword $(MAKEFILE_LIST)))/../.build/inc.mk
include definitions.mk

.PHONY: default
default: help

.PHONY: help
help:
	@echo "Format of targets:"
	@echo "  ./build/x86-gcc-limited-libc/$(call timestampOf,lang/variant)"
	@echo "Example target:"
	@echo "  ./build/x86-gcc-limited-libc/$(call timestampOf,c-cpp-execution/nd)"

# To make testing easier
ifeq ($(PROFILE),)
PROFILE = x86-gcc-limited-libc
endif


# Format: .build/x86-gcc-limited-libc/c-cpp-linking/basic/c-cpp-linking-kompiled/timestamp
KOMPILED_DEFINITION_TIMESTAMPS = $(foreach var, $(call timestampOfAll,$(LANGUAGE_VARIANTS)), .build/x86-gcc-limited-libc/$(var))

.PHONY: all
all: $(KOMPILED_DEFINITION_TIMESTAMPS)
	@echo Pre: $^


# Naming scheme:
# .build/$(PROFILE)/$(DEFINITION)/$(VARIANT)/$(DEFINITION)-kompiled/timestamp

KOMPILE_FLAGS_EXECUTION = --no-expand-macros --ocaml-serialize-config '$$PGM' --ocaml-dump-exit-code 139
KOMPILE_FLAGS_VARIANT_ND = --transition "observable ndtrans" --superheat "ndheat" --supercool "ndlocal"
KOMPILE_FLAGS_VARIANT_NDTHREAD = --transition "observable ndtrans ndthread"

getFlagsForDefinition = $(if $(findstring /c-cpp-execution/,$(1)),$(KOMPILE_FLAGS_EXECUTION))
getFlagsForVariant = $(if $(findstring /ndthread/,$(1)),$(KOMPILE_FLAGS_VARIANT_NDTHREAD)) \
		     $(if $(findstring /nd/,$(1)),$(KOMPILE_FLAGS_VARIANT_ND))
getFlags = $(call getFlagsForDefinition,$(1))$(call getFlagsForVariant,$(1))

.build/%/timestamp:
	$(eval CURRENT_FLAGS = $(call getFlags,$@))
	@echo $(CURRENT_FLAGS)
	$(MAKE) -f Makefile2 PROFILES_DIR="$(C_SEMANTICS_DIR)/profiles" "$@"
a:
	@echo A
b:
	@echo B

.PHONY: clean
clean:
	@rm -rf .build


PROFILES_DIR=$(C_SEMANTICS_DIR)/profiles

# Let us generate all the .depend files
# even if we do not want to build everything.

# See https://stackoverflow.com/a/4270649/6209703
ifneq ($(MAKECMDGOALS),clean)
  -include $(foreach var, $(LANGUAGE_VARIANTS), .build/$(PROFILE)/$(var)/depend.mk)
endif
#
#

# Naming scheme:
# .build/$(PROFILE)/$(DEFINITION)/$(VARIANT)/$(DEFINITION)-kompiled/timestamp
# .build/$(PROFILE)/$(DEFINITION)/$(VARIANT)/depend.mk

.build/%/depend.mk:
	$(call setCurrentVars,$@)
	$(eval CURRENT_PROFILE_DIR := $(PROFILES_DIR)/$(CURRENT_PROFILE_NAME))
	@echo "Generating $@"

	$(eval TMP := $(shell mktemp))
	@$(KDEP) \
		-d $(CURRENT_BUILD_DIR) \
		-I $(CURRENT_PROFILE_DIR)/semantics \
		-I $(CURRENT_PROFILE_DIR)/semantics/c \
		-I $(CURRENT_PROFILE_DIR)/semantics/cpp \
		-- $(CURRENT_DEFINITION).k > $(TMP)

	@mkdir -p $(dir $@)
	@mv $(TMP) $@

# Nondeterministic and thread version have the same dependencies.
# They difer only in rules.
# TODO: optimize generation of nonbasic variants.


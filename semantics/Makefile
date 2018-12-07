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
	#$(eval CURRENT_FLAGS = $(shell $(BUILD_DIR)/getFlags TODO)))
	@echo $(CURRENT_FLAGS)
	$(MAKE) -f Makefile2 "$@"

.PHONY: clean
clean:
	@-rm -rf */c-translation-kompiled */cpp-translation-kompiled */c-cpp-kompiled */c-nd-kompiled */c-nd-thread-kompiled .kompile-* .depend-* .build/*
#
#
KDEP_DEFAULT_FLAGS=

KDEP_DEF = $(KDEP) $(KDEP_DEFAULT_FLAGS)
KDEP_INCLUDE = -I $(PROFILE_DIR)/semantics -I $(PROFILE_DIR)/semantics/c -I $(PROFILE_DIR)/semantics/cpp

.depend-%--basic:
	@echo "Generating $@"
	$(eval LANG := $(@:.depend-$(PROFILE)-%--basic=%))
	$(eval TMP := $(shell mktemp))
	@$(KDEP_DEF) -d ".build/$(PROFILE)/$(LANG)-kompiled" $(KDEP_INCLUDE) -- $(LANG).k > $(TMP)
	@mv $(TMP) $@

# Nondeterministic and thread version have the same dependencies.
# They difer only in rules

.depend-%--nd: .depend-%--basic
	@echo "Generating $@"
	@cp $< $@

.depend-%--ndthread: .depend-%--basic
	@echo "Generating $@"
	@cp $< $@

# See https://stackoverflow.com/a/4270649/6209703
ifneq ($(MAKECMDGOALS),clean)
  -include $(LANGUAGE_DEPENDENCIES)
endif

LANGUAGE_DEFS = $(patsubst %.k,%,$(wildcard *.k))

# I think that the toplevel should enumerate or specify those...
# TODO different file?
LANGUAGE_VARIANTS = c-cpp-execution/basic    \
		    c-cpp-execution/nd       \
                    c-cpp-execution/ndthread \
		    c-translation/basic      \
		    cpp-translation/basic    \
		    c-cpp-linking/basic


# Naming scheme:
# The name of the innermost directory ($(DEFINITION)-kompiled)
# is chosen automatically by `kompile`.
# $(BUILDDIR)/$(PROFILE)/$(DEFINITION)/$(VARIANT)/$(DEFINITION)-kompiled/timestamp

# from: 'cpp-translation/basic'
# to: 'cpp-translation/basic/cpp-translation-kompiled'
kompiledDefinitionOf = $(1)/$(firstword $(subst /, ,$(1)))-kompiled
kompiledDefinitionOfAll = $(foreach var, $(1), $(call kompiledDefinitionOf,$(var)))

# from: 'cpp-translation/basic'
# to: 'cpp-translation/basic/cpp-translation-kompiled/timestamp'
timestampOf = $(call kompiledDefinitionOf,$(1))/timestamp
timestampOfAll = $(foreach var, $(1), $(call timestampOf,$(var)))

# from: 'x86-gcc-limited-libc/c-cpp-execution/basic/c-cpp-execution-kompiled/timestamp'
# to: 'x86-gcc-limited-libc c-cpp-execution basic c-cpp-execution-kompiled'
targetComponents = $(subst /, ,$(1:%/timestamp=%))

# from: 'x86-gcc-limited-libc/c-cpp-execution/basic/c-cpp-execution-kompiled/timestamp'
# to: 'x86-gcc-limited-libc'
profileNameFromTimestamp = $(word 1,$(call targetComponents,$(1)))

# from: 'x86-gcc-limited-libc/c-cpp-execution/basic/c-cpp-execution-kompiled/timestamp'
# to: 'c-cpp-execution'
languageDefinitionFromTimestamp = $(word 2,$(call targetComponents,$(1)))

# from: 'x86-gcc-limited-libc/c-cpp-execution/basic/c-cpp-execution-kompiled/timestamp'
# to: 'basic'
variantNameFromTimestamp = $(word 3,$(call targetComponents,$(1)))

define setCurrentVars
	$(eval S := $(1:.build/%=%))
	$(eval L := $(call targetComponents,$S))
	$(eval CURRENT_PROFILE_NAME := $(call profileNameFromTimestamp,$L))
	$(eval CURRENT_DEFINITION := $(call languageDefinitionFromTimestamp,$L))
	$(eval CURRENT_VARIANT := $(call variantNameFromTimestamp,$L))
	$(eval CURRENT_GOAL := $(CURRENT_PROFILE_NAME)/$(CURRENT_DEFINITION)/$(CURRENT_VARIANT))
	$(eval CURRENT_BUILD_DIR := .build/$(CURRENT_GOAL))
	$(eval CURRENT_KOMPILED_DIR := $(CURRENT_BUILD_DIR)/$(CURRENT_DEFINITION)-kompiled)
	$(eval CURRENT_TIMESTAMP := $(CURRENT_KOMPILED_DIR)/timestamp)

	@#echo '--------------------------'
	@#echo 'Target $1'
	@#echo 'S: $S'
	@#echo 'L: $L'
	@#echo 'CURRENT_PROFILE_NAME: $(CURRENT_PROFILE_NAME)'
	@#echo 'CURRENT_DEFINITION: $(CURRENT_DEFINITION)'
	@#echo 'CURRENT_VARIANT: $(CURRENT_VARIANT)'
	@#echo 'CURRENT_BUILD_DIR: $(CURRENT_BUILD_DIR)'
	@#echo 'CURRENT_KOMPILED_DIR: $(CURRENT_KOMPILED_DIR)'
	@#echo 'CURRENT_TIMESTAMP: $(CURRENT_TIMESTAMP)'

endef


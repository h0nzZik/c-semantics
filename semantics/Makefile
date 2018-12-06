
#C_TRANSLATION_FILES = $(wildcard *.k) \
#	$(wildcard language/translation/*.k) $(wildcard language/translation/*/*.k) \
#	$(wildcard language/common/*.k) $(wildcard language/common/*/*.k)
#	
#C_FILES = $(wildcard *.k) \
#	$(wildcard language/execution/*.k) $(wildcard language/execution/*/*.k) \
#	$(wildcard language/common/*.k) $(wildcard language/common/*/*.k) \
#	$(wildcard library/*.k)

# To make testing easier
ifeq ($(PROFILE),)
	PROFILE := x86-gcc-limited-libc
endif

BUILDDIR = .build
BPROFILE = $(BUILDDIR)/$(PROFILE)

# Naming scheme:
# The name of the innermost directory ($(DEFINITION)-kompiled)
# is chosen automatically by `kompile`.
# $(BUILDDIR)/$(PROFILE)/$(DEFINITION)/$(VARIANT)/$(DEFINITION)-kompiled/timestamp
# We may also provide a symlinked directory:
# $(BUILDDIR)/$(PROFILE)/$(DEFINITION)/$(VARIANT)/kompiled/

LANGUAGE_EXEC_DEFINITIONS = c-cpp-execution
LANGUAGE_NOEXEC_DEFINITIONS = c-translation cpp-translation c-cpp-linking
LANGUAGE_DEFINITIONS = $(LANGUAGE_NOEXEC_DEFINITIONS) $(LANGUAGE_EXEC_DEFINITIONS)

KOMPILED_DEFINITIONS = $(foreach var, $(LANGUAGE_DEFINITIONS), $(var)/basic/$(var)-kompiled) \
                       $(foreach var, $(LANGUAGE_EXEC_DEFINITIONS), $(var)/nd/$(var)-kompiled) \
                       $(foreach var, $(LANGUAGE_EXEC_DEFINITIONS), $(var)/ndthread/$(var)-kompiled)
		    
KOMPILED_DEFINITION_TIMESTAMPS = $(foreach var, $(KOMPILED_DEFINITIONS), $(BPROFILE)/$(var)/timestamp)
#LANGUAGE_DEPENDENCIES = $(foreach var, $(LANGUAGE_ALL_VARIANTS), .depend-$(PROFILE)-$(var))
#LANGUAGE_KOMPILEDS = $(foreach var, $(LANGUAGE_ALL_VARIANTS), $(BPROFILE)/$(var)-kompiled)
#LANGUAGE_TIMESTAMPS = $(foreach var, $(LANGUAGE_ALL_VARIANTS), $(BPROFILE)/$(var)-kompiled/$(var)-kompiled/timestamp)

KOMPILE_DEF = $(KOMPILE) $(KOMPILE_DEFAULT_FLAGS) --no-prelude -I $(PROFILE_DIR)/semantics -w all -v --debug
KOMPILE_CPP = $(KOMPILE_DEF) $(CPP_KOMPILE_FLAGS)

# < API Targets >

.PHONY: default
default: $(KOMPILED_DEFINITION_TIMESTAMPS)

## TODO deal with those later
#.PHONY: nd
#nd: $(call timestamp_of,c-nd)
#
#.PHONY: thread
#thread: $(call timestamp_of,c-nd-thread)

KOMPILE_DEFAULT_FLAGS=--backend ocaml --non-strict --smt none
CPP_KOMPILE_FLAGS=--opaque-klabels c-translation.k
EXECUTION_KOMPILE_FLAGS=--opaque-klabels cpp-translation.k --no-expand-macros --ocaml-serialize-config '$$PGM' --ocaml-dump-exit-code 139

#define timestamp_of
#    $(BPROFILE)/$(1)/$(2)/$(1)-kompiled/timestamp
#endef
#
#.PHONY: $(MAIN_TARGETS)
#c-translation: $(call timestamp_of,c-translation)
#cpp-translation: $(call timestamp_of,cpp-translation)
#c-cpp-linking: $(call timestamp_of,c-cpp-linking)
#c-cpp-execution: $(call timestamp_of,c-cpp-execution)
#
#
#
## NEW version
#c-translation: $(BPROFILE)/c-translation/basic/c-translation-kompiled/timestamp
#cpp-translation: $(BPROFILE)/cpp-translation/basic/c-translation-kompiled/timestamp
#c-cpp-linking: $(BPROFILE)/c-cpp-linking/basic/c-translation-kompiled/timestamp
#c-cpp-execution: $(BPROFILE)/c-cpp-execution/basic/c-cpp-execution-kompiled/timestamp

# Naming scheme:
# $(BUILDDIR)/$(PROFILE)/$(DEFINITION)/$(VARIANT)/$(DEFINITION)-kompiled/timestamp

$(BUILDDIR)/%/timestamp:
	$(eval L := $(subst /, ,$(@:$(BUILDDIR)/%/timestamp=%)))
	$(eval MY_PROFILE := $(word 1, $L))
	$(eval MY_DEFINITION := $(word 2, $L))
	$(eval MY_VARIANT := $(word 3, $L))
	@echo "--------------------------"
	@echo "Building $@"
	@echo "L: $L"
	@echo "MY_PROFILE: $(MY_PROFILE)"
	@echo "MY_DEFINITION: $(MY_DEFINITION)"
	@echo "MY_VARIANT: $(MY_VARIANT)"
	@echo "Kompiling $(MY_DEFINITION)/$(MY_VARIANT)"

## some-path/name-of-semantics/variant
#
#
## </API Targets >
#
#$(call timestamp_of,c-translation):
#	@echo "Kompiling the static C semantics..."
#	@echo "Target: $@"
#	$(KOMPILE_DEF) c-translation.k -d "$(BPROFILE)/c-translation-kompiled"
#
#$(call timestamp_of,cpp-translation):
#	@echo "Kompiling the static C++ semantics..."
#	@echo "Target: $@"
#	$(KOMPILE_CPP) cpp-translation.k -d "$(BPROFILE)/cpp-translation-kompiled"
#
#$(call timestamp_of,c-cpp-linking):
#	@echo "Kompiling the C and C++ linking semantics..."
#	@echo "Target: $@"
#	$(KOMPILE_CPP) c-cpp-linking.k -d "$(BPROFILE)/c-cpp-linking-kompiled"
#
#KOMPILE_EXEC = $(KOMPILE_DEF) $(EXECUTION_KOMPILE_FLAGS) c-cpp-execution.k
#
#$(call timestamp_of,c-cpp):
#	@echo "Kompiling the dynamic C and C++ semantics..."
#	$(KOMPILE_EXEC) -d "$(BPROFILE)/c-cpp-kompiled" --transition "interpRule"
#
#$(call timestamp_of,c-nd):
#	@echo "Kompiling the dynamic C and C++ semantics with expression sequencing non-determinism..."
#	$(KOMPILE_EXEC) -d "$(BPROFILE)/c-nd-kompiled" --transition "observable ndtrans" --superheat "ndheat" --supercool "ndlocal"
#
#$(call timestamp_of,c-nd-thread):
#	@echo "Kompiling the dynamic C and C++ semantics with thread-interleaving non-determinism..."
#	$(KOMPILE_EXEC) -d "$(BPROFILE)/c-nd-thread-kompiled" --transition "observable ndtrans ndthread"
#
#.PHONY: all
#all: fast nd thread
#
.PHONY: clean
clean:
	@-rm -rf */c-translation-kompiled */cpp-translation-kompiled */c-cpp-kompiled */c-nd-kompiled */c-nd-thread-kompiled .kompile-* .depend-* .build/*
#
#
KDEP_DEFAULT_FLAGS=
#
#KDEP_DEF = $(KDEP) $(KDEP_DEFAULT_FLAGS)
#KDEP_INCLUDE = -I $(PROFILE_DIR)/semantics -I $(PROFILE_DIR)/semantics/c -I $(PROFILE_DIR)/semantics/cpp
#
#.depend-%--basic:
#	@echo "Generating $@"
#	$(eval LANG := $(@:.depend-$(PROFILE)-%--basic=%))
#	$(eval TMP := $(shell mktemp))
#	@$(KDEP_DEF) -d "$(BPROFILE)/$(LANG)-kompiled" $(KDEP_INCLUDE) -- $(LANG).k > $(TMP)
#	@mv $(TMP) $@
#
## Nondeterministic and thread version have the same dependencies.
## They difer only in rules
#
#.depend-%--nd: .depend-%--basic
#	@echo "Generating $@"
#	@cp $< $@
#
#.depend-%--ndthread: .depend-%--basic
#	@echo "Generating $@"
#	@cp $< $@
#
## See https://stackoverflow.com/a/4270649/6209703
#ifneq ($(MAKECMDGOALS),clean)
#  -include $(LANGUAGE_DEPENDENCIES)
#endif

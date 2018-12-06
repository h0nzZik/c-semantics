KOMPILE_DEFAULT_FLAGS=--backend ocaml --non-strict --smt none
CPP_KOMPILE_FLAGS=--opaque-klabels c11-translation.k
EXECUTION_KOMPILE_FLAGS=--opaque-klabels cpp14-translation.k --no-expand-macros --ocaml-serialize-config '$$PGM' --ocaml-dump-exit-code 139
KDEP_DEFAULT_FLAGS=

C11_TRANSLATION_FILES = $(wildcard *.k) \
	$(wildcard language/translation/*.k) $(wildcard language/translation/*/*.k) \
	$(wildcard language/common/*.k) $(wildcard language/common/*/*.k)
	
C11_FILES = $(wildcard *.k) \
	$(wildcard language/execution/*.k) $(wildcard language/execution/*/*.k) \
	$(wildcard language/common/*.k) $(wildcard language/common/*/*.k) \
	$(wildcard library/*.k)

BPROFILE=".build/$(PROFILE)"
define timestamp_of
    $(BPROFILE)/$(1)-kompiled/$(1)-kompiled/timestamp
endef

.PHONY: default
default: fast

KOMPILE_DEF = $(KOMPILE) $(KOMPILE_DEFAULT_FLAGS) --no-prelude -I $(PROFILE_DIR)/semantics -w all -v --debug
KOMPILE_CPP = $(KOMPILE_DEF) $(CPP_KOMPILE_FLAGS)

$(call timestamp_of,c11-translation):
	@echo "Kompiling the static C semantics..."
	$(KOMPILE_DEF) c11-translation.k -d "$(BPROFILE)/c11-translation-kompiled"

$(call timestamp_of,cpp14-translation):
	@echo "Kompiling the static C++ semantics..."
	$(KOMPILE_CPP) cpp14-translation.k -d "$(BPROFILE)/cpp14-translation-kompiled"

$(call timestamp_of,c11-cpp14-linking):
	@echo "Kompiling the C and C++ linking semantics..."
	$(KOMPILE_CPP) c11-cpp14-linking.k -d "$(BPROFILE)/c11-cpp14-linking-kompiled"

KOMPILE_EXEC = $(KOMPILE_DEF) $(EXECUTION_KOMPILE_FLAGS) c11-cpp14.k

$(call timestamp_of,c11-cpp14):
	@echo "Kompiling the dynamic C and C++ semantics..."
	$(KOMPILE_EXEC) -d "$(BPROFILE)/c11-cpp14-kompiled" --transition "interpRule"

$(call timestamp_of,c11-nd):
	@echo "Kompiling the dynamic C and C++ semantics with expression sequencing non-determinism..."
	$(KOMPILE_EXEC) -d "$(BPROFILE)/c11-nd-kompiled" --transition "observable ndtrans" --superheat "ndheat" --supercool "ndlocal"

$(call timestamp_of,c11-nd-thread):
	@echo "Kompiling the dynamic C and C++ semantics with thread-interleaving non-determinism..."
	$(KOMPILE_EXEC) -d "$(BPROFILE)/c11-nd-thread-kompiled" --transition "observable ndtrans ndthread"

.PHONY: all
all: fast nd thread

.PHONY: fast
fast: translation execution linking

.PHONY: fast-cpp
fast-cpp: translation execution linking cpp

.PHONY: translation
translation: $(call timestamp_of,c11-translation)

.PHONY: linking
linking: $(call timestamp_of,c11-cpp14-linking)

.PHONY: cpp
cpp: $(call timestamp_of,cpp14-translation)

.PHONY: execution
execution: $(call timestamp_of,c11-cpp14)

.PHONY: nd
nd: $(call timestamp_of,c11-nd)

.PHONY: thread
thread: $(call timestamp_of,c11-nd-thread)

.PHONY: clean
clean:
	@-rm -rf */c11-translation-kompiled */cpp14-translation-kompiled */c11-cpp14-kompiled */c11-nd-kompiled */c11-nd-thread-kompiled .kompile-* .depend-* .build/*

.PHONY: .depend-$(PROFILE)-translation .depend-$(PROFILE)-execution .depend-$(PROFILE)-linking .depend-$(PROFILE)-nd .depend-$(PROFILE)-nd-thread .depend-$(PROFILE)-cpp

KDEP_BASE = $(KDEP) -I $(PROFILE_DIR)/semantics
KDEP_DEF = $(KDEP_BASE) $(KDEP_DEFAULT_FLAGS)
KDEP_BOTH = -I $(PROFILE_DIR)/semantics/c -I $(PROFILE_DIR)/semantics/cpp
KDEP_EXEC = $(KDEP_BOTH) -- c11-cpp14.k

.depend-$(PROFILE)-translation:
	$(eval TMP := $(shell mktemp))
	$(KDEP_DEF) -d "$(BPROFILE)/c11-translation-kompiled" -I $(PROFILE_DIR)/semantics/c -- c11-translation.k > $(TMP)
	mv $(TMP) $@

.depend-$(PROFILE)-cpp:
	$(eval TMP := $(shell mktemp))
	$(KDEP_DEF) -d "$(BPROFILE)/cpp14-translation-kompiled" $(KDEP_BOTH) -- cpp14-translation.k > $(TMP)
	mv $(TMP) $@

.depend-$(PROFILE)-linking:
	$(eval TMP := $(shell mktemp))
	$(KDEP_DEF) -d "$(BPROFILE)/c11-cpp14-linking-kompiled" $(KDEP_BOTH) -- c11-cpp14-linking.k > $(TMP)
	mv $(TMP) $@

.depend-$(PROFILE)-execution:
	$(eval TMP := $(shell mktemp))
	$(KDEP_DEF) -d "$(BPROFILE)/c11-cpp14-kompiled" $(KDEP_EXEC) > $(TMP)
	mv $(TMP) $@

.depend-$(PROFILE)-nd:
	$(eval TMP := $(shell mktemp))
	$(KDEP_BASE) -d "$(BPROFILE)/c11-nd-kompiled" $(KDEP_EXEC) > $(TMP)
	mv $(TMP) $@

.depend-$(PROFILE)-nd-thread:
	$(eval TMP := $(shell mktemp))
	$(KDEP_BASE) -d "$(BPROFILE)/c11-nd-thread-kompiled" $(KDEP_EXEC) > $(TMP)
	mv $(TMP) $@

# See https://stackoverflow.com/a/4270649/6209703
ifneq ($(MAKECMDGOALS),clean)
  -include .depend-$(PROFILE)-translation
  -include .depend-$(PROFILE)-cpp
  -include .depend-$(PROFILE)-linking
  -include .depend-$(PROFILE)-execution
  -include .depend-$(PROFILE)-nd
  -include .depend-$(PROFILE)-nd-thread
endif

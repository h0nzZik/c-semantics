KOMPILE_DEFAULT_FLAGS=--backend ocaml --non-strict --smt none
CPP_KOMPILE_FLAGS=--opaque-klabels c-translation.k
EXECUTION_KOMPILE_FLAGS=--opaque-klabels cpp-translation.k --no-expand-macros --ocaml-serialize-config '$$PGM' --ocaml-dump-exit-code 139
KDEP_DEFAULT_FLAGS=

C11_TRANSLATION_FILES = $(wildcard *.k) \
	$(wildcard language/translation/*.k) $(wildcard language/translation/*/*.k) \
	$(wildcard language/common/*.k) $(wildcard language/common/*/*.k)
	
C11_FILES = $(wildcard *.k) \
	$(wildcard language/execution/*.k) $(wildcard language/execution/*/*.k) \
	$(wildcard language/common/*.k) $(wildcard language/common/*/*.k) \
	$(wildcard library/*.k)

.PHONY: default all fast nd thread clean .depend-$(PROFILE)-translation .depend-$(PROFILE)-execution .depend-$(PROFILE)-linking .depend-$(PROFILE)-nd .depend-$(PROFILE)-nd-thread .depend-$(PROFILE)-cpp

define timestamp_of
    .build/$(PROFILE)/$(1)-kompiled/$(1)-kompiled/timestamp
endef

default: fast

$(call timestamp_of,c-translation):
	@echo "Kompiling the static C semantics..."
	$(KOMPILE) $(KOMPILE_DEFAULT_FLAGS) c-translation.k -d ".build/$(PROFILE)/c-translation-kompiled" --no-prelude -w all -v --debug -I $(PROFILE_DIR)/semantics

$(call timestamp_of,cpp-translation):
	@echo "Kompiling the static C++ semantics..."
	$(KOMPILE) $(KOMPILE_DEFAULT_FLAGS) $(CPP_KOMPILE_FLAGS) cpp-translation.k -d ".build/$(PROFILE)/cpp-translation-kompiled" --no-prelude -w all -v --debug -I $(PROFILE_DIR)/semantics

$(call timestamp_of,c-cpp-linking):
	@echo "Kompiling the C and C++ linking semantics..."
	$(KOMPILE) $(KOMPILE_DEFAULT_FLAGS) $(CPP_KOMPILE_FLAGS) c-cpp-linking.k -d ".build/$(PROFILE)/c-cpp-linking-kompiled" --no-prelude -w all -v --debug -I $(PROFILE_DIR)/semantics

$(call timestamp_of,c-cpp-execution):
	@echo "Kompiling the dynamic C and C++ semantics..."
	$(KOMPILE) $(KOMPILE_DEFAULT_FLAGS) $(EXECUTION_KOMPILE_FLAGS) c-cpp-execution.k -d ".build/$(PROFILE)/c-cpp-execution-kompiled" --no-prelude -w all -v --transition "interpRule" --debug -I $(PROFILE_DIR)/semantics

$(call timestamp_of,c11-nd):
	@echo "Kompiling the dynamic C and C++ semantics with expression sequencing non-determinism..."
	$(KOMPILE) $(KOMPILE_DEFAULT_FLAGS) $(EXECUTION_KOMPILE_FLAGS) c-cpp-execution.k -d ".build/$(PROFILE)/c11-nd-kompiled" --no-prelude --transition "observable ndtrans" --superheat "ndheat" --supercool "ndlocal" -I $(PROFILE_DIR)/semantics

$(call timestamp_of,c11-nd-thread):
	@echo "Kompiling the dynamic C and C++ semantics with thread-interleaving non-determinism..."
	$(KOMPILE) $(KOMPILE_DEFAULT_FLAGS) $(EXECUTION_KOMPILE_FLAGS) c-cpp-execution.k -d ".build/$(PROFILE)/c11-nd-thread-kompiled" --no-prelude --transition "observable ndtrans ndthread" -I $(PROFILE_DIR)/semantics

all: fast nd thread

fast: translation execution linking

fast-cpp: translation execution linking cpp

translation: $(call timestamp_of,c-translation)

linking: $(call timestamp_of,c-cpp-linking)

cpp: $(call timestamp_of,cpp-translation)

execution: $(call timestamp_of,c-cpp-execution)

nd: $(call timestamp_of,c11-nd)

thread: $(call timestamp_of,c11-nd-thread)

clean:
	@-rm -rf */c-translation-kompiled */cpp-translation-kompiled */c-cpp-execution-kompiled */c11-nd-kompiled */c11-nd-thread-kompiled .kompile-* .depend-* .build/*

.depend-$(PROFILE)-translation:
	$(eval TMP := $(shell mktemp))
	$(KDEP) $(KDEP_DEFAULT_FLAGS) -d ".build/$(PROFILE)/c-translation-kompiled" -I $(PROFILE_DIR)/semantics -I $(PROFILE_DIR)/semantics/c -- c-translation.k > $(TMP)
	mv $(TMP) $@
.depend-$(PROFILE)-cpp:
	$(eval TMP := $(shell mktemp))
	$(KDEP) $(KDEP_DEFAULT_FLAGS) -d ".build/$(PROFILE)/cpp-translation-kompiled" -I $(PROFILE_DIR)/semantics -I $(PROFILE_DIR)/semantics/cpp -I $(PROFILE_DIR)/semantics/c -- cpp-translation.k > $(TMP)
	mv $(TMP) $@
.depend-$(PROFILE)-linking:
	$(eval TMP := $(shell mktemp))
	$(KDEP) $(KDEP_DEFAULT_FLAGS) -d ".build/$(PROFILE)/c-cpp-linking-kompiled" -I $(PROFILE_DIR)/semantics -I $(PROFILE_DIR)/semantics/cpp -I $(PROFILE_DIR)/semantics/c -- c-cpp-linking.k > $(TMP)
	mv $(TMP) $@
.depend-$(PROFILE)-execution:
	$(eval TMP := $(shell mktemp))
	$(KDEP) $(KDEP_DEFAULT_FLAGS) -d ".build/$(PROFILE)/c-cpp-execution-kompiled" -I $(PROFILE_DIR)/semantics -I $(PROFILE_DIR)/semantics/c -I $(PROFILE_DIR)/semantics/cpp -- c-cpp-execution.k > $(TMP)
	mv $(TMP) $@
.depend-$(PROFILE)-nd:
	$(eval TMP := $(shell mktemp))
	$(KDEP) -d ".build/$(PROFILE)/c11-nd-kompiled" -I $(PROFILE_DIR)/semantics -I $(PROFILE_DIR)/semantics/c -I $(PROFILE_DIR)/semantics/cpp -- c-cpp-execution.k > $(TMP)
	mv $(TMP) $@
.depend-$(PROFILE)-nd-thread:
	$(eval TMP := $(shell mktemp))
	$(KDEP) -d ".build/$(PROFILE)/c11-nd-thread-kompiled" -I $(PROFILE_DIR)/semantics -I $(PROFILE_DIR)/semantics/c -I $(PROFILE_DIR)/semantics/cpp -- c-cpp-execution.k > $(TMP)
	mv $(TMP) $@

-include .depend-$(PROFILE)-translation
-include .depend-$(PROFILE)-cpp
-include .depend-$(PROFILE)-linking
-include .depend-$(PROFILE)-execution
-include .depend-$(PROFILE)-nd
-include .depend-$(PROFILE)-nd-thread

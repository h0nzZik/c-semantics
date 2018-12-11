ifeq ($(strip $(BUILD_DIR)),)
  $(error Need BUILD_DIR)
endif

ifeq ($(strip $(BUILD_ROOT)),)
  $(error Need BUILD_ROOT)
endif

ifeq ($(strip $(PROFILE)),)
  $(error Need PROFILE)
endif

ifeq ($(strip $(PROFILE_DIR)),)
  $(error Need PROFILE_DIR)
endif

include $(BUILD_ROOT)/deps/deps.mk

B := $(BUILD_DIR)
BP := $(B)/$(PROFILE)


KOMPILE_DEFAULT_FLAGS := --backend ocaml --non-strict --smt none
CPP_KOMPILE_FLAGS := --opaque-klabels c11-translation.k
EXECUTION_KOMPILE_FLAGS := --opaque-klabels cpp14-translation.k --no-expand-macros --ocaml-serialize-config '$$PGM' --ocaml-dump-exit-code 139
KDEP_DEFAULT_FLAGS :=

define timestamp_of
    $(BP)/$(1)-kompiled/$(1)-kompiled/timestamp
endef

.PHONY: default
default: fast

$(call timestamp_of,c11-translation):
	@echo "Kompiling the static C semantics..."
	$(KOMPILE) $(KOMPILE_DEFAULT_FLAGS) c11-translation.k -d "$(BP)/c11-translation-kompiled" --no-prelude -w all -v --debug -I $(PROFILE_DIR)/semantics

$(call timestamp_of,cpp14-translation):
	@echo "Kompiling the static C++ semantics..."
	$(KOMPILE) $(KOMPILE_DEFAULT_FLAGS) $(CPP_KOMPILE_FLAGS) cpp14-translation.k -d "$(BP)/cpp14-translation-kompiled" --no-prelude -w all -v --debug -I $(PROFILE_DIR)/semantics

$(call timestamp_of,c11-cpp14-linking):
	@echo "Kompiling the C and C++ linking semantics..."
	$(KOMPILE) $(KOMPILE_DEFAULT_FLAGS) $(CPP_KOMPILE_FLAGS) c11-cpp14-linking.k -d "$(BP)/c11-cpp14-linking-kompiled" --no-prelude -w all -v --debug -I $(PROFILE_DIR)/semantics

$(call timestamp_of,c11-cpp14):
	@echo "Kompiling the dynamic C and C++ semantics..."
	$(KOMPILE) $(KOMPILE_DEFAULT_FLAGS) $(EXECUTION_KOMPILE_FLAGS) c11-cpp14.k -d "$(BP)/c11-cpp14-kompiled" --no-prelude -w all -v --transition "interpRule" --debug -I $(PROFILE_DIR)/semantics

$(call timestamp_of,c11-nd):
	@echo "Kompiling the dynamic C and C++ semantics with expression sequencing non-determinism..."
	$(KOMPILE) $(KOMPILE_DEFAULT_FLAGS) $(EXECUTION_KOMPILE_FLAGS) c11-cpp14.k -d "$(BP)/c11-nd-kompiled" --no-prelude --transition "observable ndtrans" --superheat "ndheat" --supercool "ndlocal" -I $(PROFILE_DIR)/semantics

$(call timestamp_of,c11-nd-thread):
	@echo "Kompiling the dynamic C and C++ semantics with thread-interleaving non-determinism..."
	$(KOMPILE) $(KOMPILE_DEFAULT_FLAGS) $(EXECUTION_KOMPILE_FLAGS) c11-cpp14.k -d "$(BP)/c11-nd-thread-kompiled" --no-prelude --transition "observable ndtrans ndthread" -I $(PROFILE_DIR)/semantics

.PHONY: all
all: fast nd thread

.PHONY: fast
fast: $(addsuffix -semantics,c11-translation c11-cpp14 c11-cpp14)

.PHONY: fast-cpp
fast-cpp: $(addsuffix -semantics,c11-translation c11-cpp14 c11-cpp14-linking cpp14-translation)

XYZ_SEMANTICS := $(addsuffix -semantics,c11-translation cpp14-translation c11-cpp14-linking c11-cpp14)
.PHONY: $(XYZ_SEMANTICS)
.SECONDEXPANSION:
$(XYZ_SEMANTICS): %-semantics: $(call timestamp_of,$$*)

.PHONY: nd
nd: $(call timestamp_of,c11-nd)

.PHONY: thread
thread: $(call timestamp_of,c11-nd-thread)

.PHONY: clean
clean:
	@-rm -rf */c11-translation-kompiled */cpp14-translation-kompiled */c11-cpp14-kompiled */c11-nd-kompiled */c11-nd-thread-kompiled .kompile-*
	@-rm -rf .kompile-*
	@-rm -rf .depend-* $(B)/*

BASIC_DEPENDS := $(addprefix $(BP)/.depend-$(PROFILE)-basic-,c11-translation cpp14-translation c11-cpp14-linking c11-cpp14)
SPECIAL_DEPENDS := $(BP)/.depend-$(PROFILE)-nd $(BP)/.depend-$(PROFILE)-nd-thread
DEPENDS := $(BASIC_DEPENDS) $(SPECIAL_DEPENDS)

.PHONY: $(DEPENDS)

# See https://stackoverflow.com/a/4270649/6209703
ifneq ($(MAKECMDGOALS),clean)
  -include $(DEPENDS)
endif

KDEP_FLAGS := $(KDEP_DEFAULT_FlAGS)
KDEP_FLAGS += -I $(PROFILE_DIR)/semantics
KDEP_FLAGS += -I $(PROFILE_DIR)/semantics/c
KDEP_FLAGS += -I $(PROFILE_DIR)/semantics/cpp

$(BASIC_DEPENDS): $(BP)/.depend-$(PROFILE)-basic-%:
	$(eval TMP := $(shell mktemp))
	$(KDEP) $(KDEP_FLAGS) -d "$(B)/$(PROFILE)/$*-kompiled" -- $*.k > $(TMP)
	mv $(TMP) $@

$(BP)/.depend-$(PROFILE)-nd:
	$(eval TMP := $(shell mktemp))
	$(KDEP) $(KDEP_FLAGS) -d "$(BP)/c11-nd-kompiled" -- c11-cpp14.k > $(TMP)
	mv $(TMP) $@

$(BP)/.depend-$(PROFILE)-nd-thread:
	$(eval TMP := $(shell mktemp))
	$(KDEP) $(KDEP_FLAGS) -d "$(BP)/c11-nd-thread-kompiled" -- c11-cpp14.k > $(TMP)
	mv $(TMP) $@


include ../../inc.mk

ifeq ($(strip $(PROFILE)),)
  $(error Need PROFILE)
endif

ifeq ($(strip $(PROFILE_DIR)),)
  $(error Need PROFILE_DIR)
endif

BP := $(B)/$(PROFILE)

KOMPILE_DEFAULT_FLAGS := --backend ocaml --non-strict --smt none
CPP_KOMPILE_FLAGS := --opaque-klabels c11-translation.k
EXECUTION_KOMPILE_FLAGS := --opaque-klabels cpp14-translation.k --no-expand-macros --ocaml-serialize-config '$$PGM' --ocaml-dump-exit-code 139
KDEP_DEFAULT_FLAGS :=

timestamp_of = $(BP)/$(1)-kompiled/$(1)-kompiled/timestamp

ifeq ($(strip $(BUILD_DEFS)),)
  BUILD_DEFS := c-and-cpp
endif

ifeq ($(strip $(BUILD_DEFS)),only-c)
  DEFS_TO_BUILD := c11-translation c11-cpp14-linking c11-cpp14
else
  ifeq ($(strip $(BUILD_DEFS)),c-and-cpp)
    DEFS_TO_BUILD := c11-translation cpp14-translation c11-cpp14-linking c11-cpp14
  else
    ifeq ($(strip $(BUILD_DEFS)),everything)
      DEFS_TO_BUILD := c11-nd c11-thread c11-translation cpp14-translation c11-cpp14-linking c11-cpp14
    else
      $(error values for BUILD_DEFS: only-c, c-and-cpp, everything)
    endif
  endif
endif

TIMESTAMPS_TO_BUILD := $(foreach var,$(DEFS_TO_BUILD), $(call timestamp_of,$(var)))
$(info TIMESTAMPS_TO_BUILD: $(TIMESTAMPS_TO_BUILD))

.PHONY: default
default: build #dist

.PHONY: build
build: $(TIMESTAMPS_TO_BUILD)

$(call timestamp_of,c11-translation):
	@$(GENERATING)
	@echo "Kompiling the static C semantics..."
	$(KOMPILE) $(KOMPILE_DEFAULT_FLAGS) c11-translation.k -d "$(BP)/c11-translation-kompiled" --no-prelude -w all -v --debug -I $(PROFILE_DIR)/semantics

$(call timestamp_of,cpp14-translation):
	@$(GENERATING)
	@echo "Kompiling the static C++ semantics..."
	$(KOMPILE) $(KOMPILE_DEFAULT_FLAGS) $(CPP_KOMPILE_FLAGS) cpp14-translation.k -d "$(BP)/cpp14-translation-kompiled" --no-prelude -w all -v --debug -I $(PROFILE_DIR)/semantics

$(call timestamp_of,c11-cpp14-linking):
	@$(GENERATING)
	@echo "Kompiling the C and C++ linking semantics..."
	$(KOMPILE) $(KOMPILE_DEFAULT_FLAGS) $(CPP_KOMPILE_FLAGS) c11-cpp14-linking.k -d "$(BP)/c11-cpp14-linking-kompiled" --no-prelude -w all -v --debug -I $(PROFILE_DIR)/semantics

$(call timestamp_of,c11-cpp14):
	@$(GENERATING)
	@echo "Kompiling the dynamic C and C++ semantics..."
	$(KOMPILE) $(KOMPILE_DEFAULT_FLAGS) $(EXECUTION_KOMPILE_FLAGS) c11-cpp14.k -d "$(BP)/c11-cpp14-kompiled" --no-prelude -w all -v --transition "interpRule" --debug -I $(PROFILE_DIR)/semantics

$(call timestamp_of,c11-nd):
	@$(GENERATING)
	@echo "Kompiling the dynamic C and C++ semantics with expression sequencing non-determinism..."
	$(KOMPILE) $(KOMPILE_DEFAULT_FLAGS) $(EXECUTION_KOMPILE_FLAGS) c11-cpp14.k -d "$(BP)/c11-nd-kompiled" --no-prelude --transition "observable ndtrans" --superheat "ndheat" --supercool "ndlocal" -I $(PROFILE_DIR)/semantics

$(call timestamp_of,c11-nd-thread):
	@$(GENERATING)
	@echo "Kompiling the dynamic C and C++ semantics with thread-interleaving non-determinism..."
	$(KOMPILE) $(KOMPILE_DEFAULT_FLAGS) $(EXECUTION_KOMPILE_FLAGS) c11-cpp14.k -d "$(BP)/c11-nd-thread-kompiled" --no-prelude --transition "observable ndtrans ndthread" -I $(PROFILE_DIR)/semantics

XYZ_SEMANTICS := $(addsuffix -semantics,c11-translation cpp14-translation c11-cpp14-linking c11-cpp14)
.PHONY: $(XYZ_SEMANTICS)
.SECONDEXPANSION:
$(XYZ_SEMANTICS): %-semantics: $(call timestamp_of,$$*)

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
	@$(GENERATING)
	$(eval TMP := $(shell mktemp))
	$(KDEP) $(KDEP_FLAGS) -d "$(B)/$(PROFILE)/$*-kompiled" -- $*.k > $(TMP)
	mkdir -p $(dir $@)
	mv $(TMP) $@

$(BP)/.depend-$(PROFILE)-nd:
	@$(GENERATING)
	$(eval TMP := $(shell mktemp))
	$(KDEP) $(KDEP_FLAGS) -d "$(BP)/c11-nd-kompiled" -- c11-cpp14.k > $(TMP)
	mkdir -p $(dir $@)
	mv $(TMP) $@

$(BP)/.depend-$(PROFILE)-nd-thread:
	@$(GENERATING)
	$(eval TMP := $(shell mktemp))
	$(KDEP) $(KDEP_FLAGS) -d "$(BP)/c11-nd-thread-kompiled" -- c11-cpp14.k > $(TMP)
	mkdir -p $(dir $@)
	mv $(TMP) $@


.PHONY: dist
dist: $(DIST_ROOT)/profiles/$(PROFILE)

$(DIST_ROOT)/profiles/$(PROFILE):
	@mkdir -p $@/lib
	@printf "%s" $(PROFILE) > $(DIST_ROOT)/current-profile
	@printf "%s" $(PROFILE) > $(DIST_ROOT)/default-profile


export C_SEMANTICS_DIR := $(realpath $(dir $(realpath $(lastword $(MAKEFILE_LIST)))))

ifeq ($(strip $(BUILD_DIR)),)
  BUILD_DIR := $(C_SEMANTICS_DIR)/build
endif

.PHONY: default
.default: help

.PHONY: help
help:
	@echo 'Targets:'
	@echo '  help (*)'
	@echo '  default (*)'
	@echo '  deps'
	@echo '  build'
	@echo '  dist'
	@echo 'Variables:'
	@echo '  BUILD_DIR := $(BUILD_DIR)'


TARGETS := deps build dist
.PHONY: $(TARGETS)
deps: private-deps
build: private-src
dist: private-dist

PRTARGETS := deps src dist
PRTARGETS2 := $(addprefix private-,$(PRTARGETS))
.PHONY: $(PRTARGETS2)
$(PRTARGETS2): private-%: $(BUILD_DIR)/%/timestamp

BTARGETS := $(addprefix $(BUILD_DIR)/,$(addsuffix /timestamp,$(PRTARGETS)))
.PHONY: $(BTARGETS)
$(BTARGETS): $(BUILD_DIR)/%/timestamp:
	mkdir -p $(dir $@)
	$(MAKE) -C $* BUILD_DIR=$(BUILD_DIR)/$*
	touch $@

$(BUILD_DIR)/src/timestamp: $(BUILD_DIR)/deps/timestamp
$(BUILD_DIR)/dist/timestamp: $(BUILD_DIR)/src/timestamp

# TODO maybe it would be better if we didn't have ./deps directory,
# but if every directory in ./src would have its ./deps subdirectory.
# Or not? NO! We want to know in advance what is needed.
# Maybe we may have an 'obtain-deps' and 'build-deps' target.

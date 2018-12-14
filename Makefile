export C_SEMANTICS_DIR := $(realpath $(dir $(realpath $(lastword $(MAKEFILE_LIST)))))

ifeq ($(strip $(BUILD_DIR)),)
  $(error Need to provide BUILD_DIR. Use `./make`)
  BUILD_DIR := $(C_SEMANTICS_DIR)/build
endif

# TODO we should be able to have the build/deps directory elsewhere.
# Either build/deps may be symlinked,
# or we may redirect it elsewhere, i.e.
# using include chains...

export BUILD_ROOT := $(BUILD_DIR)

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


# Dependencies
build: deps
dist: build

.PHONY: build
build: build.default

build.%: FORCE
	$(eval SUBTARGET := $(@:build.%=%))
	@mkdir -p $(BUILD_DIR)/src
	@$(MAKE) -C src $(SUBTARGET) BUILD_DIR=$(BUILD_DIR)/src

.PHONY: deps dist
deps dist: %: %.default

deps.% dist.%: FORCE
	$(eval MAINTARGET := $(firstword $(subst ., ,$@)))
	$(eval SUBTARGET := $(@:$(MAINTARGET).%=%))
	@mkdir -p $(BUILD_DIR)/$(MAINTARGET)
	@$(MAKE) -C $(MAINTARGET) $(SUBTARGET) BUILD_DIR=$(BUILD_DIR)/$(MAINTARGET)


# see http://clarkgrubb.com/makefile-style-guide#phony-targets
FORCE:

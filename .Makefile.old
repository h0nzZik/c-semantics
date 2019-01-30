ifeq ($(strip $(BUILD_ROOT)),)
  $(error Need to provide BUILD_DIR. Use `./make`)
endif
export BUILD_ROOT

ifeq ($(strip $(DIST_ROOT)),)
  $(info DIST_ROOT not provided)
  DIST_ROOT := $(BUILD_ROOT)/dist
  $(info DIST_ROOT := $(DIST_ROOT))
endif
export DIST_ROOT

# TODO we should be able to have the build/deps directory elsewhere.
# Either build/deps may be symlinked,
# or we may redirect it elsewhere, i.e.
# using include chains...

BUILD_DIR := $(BUILD_ROOT)

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

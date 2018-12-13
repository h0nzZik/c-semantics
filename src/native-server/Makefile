ifeq ($(strip $(BUILD_DIR)),)
  $(error Need BUILD_DIR)
endif

THIS_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

PROFILE := x86-gcc-limited-libc
PROFILE_DIR := $(realpath $(THIS_DIR)/../profiles)/$(PROFILE)

.PHONY: default
default:
	@mkdir -p $(BUILD_DIR)/$(PROFILE)
	@$(MAKE) -C src PROFILE=$(PROFILE) PROFILE_DIR=$(PROFILE_DIR) BUILD_DIR=$(BUILD_DIR)

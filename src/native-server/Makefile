THIS_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

include ../inc.mk

PROFILE := x86-gcc-limited-libc
PROFILE_DIR := $(realpath $(THIS_DIR)/../profiles)/$(PROFILE)

.PHONY: default
default:
	@mkdir -p $(B)/$(PROFILE)
	@$(MAKE) -C src PROFILE=$(PROFILE) PROFILE_DIR=$(PROFILE_DIR) BUILD_DIR=$(B)

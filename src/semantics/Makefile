THIS_MAKEFILE := $(lastword $(MAKEFILE_LIST))
THIS_MAKEFILE_DIR := $(dir $(realpath $(THIS_MAKEFILE)))

include ../inc.mk

PROFILE := x86-gcc-limited-libc
PROFILE_DIR := $(realpath $(THIS_MAKEFILE_DIR)/../profiles)/$(PROFILE)

.PHONY: default
default:
	@$(MAKE) -C src PROFILE=$(PROFILE) PROFILE_DIR=$(PROFILE_DIR) BUILD_DIR=$(BUILD_DIR)

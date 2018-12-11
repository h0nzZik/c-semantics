ifeq ($(strip $(BUILD_DIR)),)
  $(error Need BUILD_DIR)
endif

ifeq ($(strip $(BUILD_ROOT)),)
  $(error Need BUILD_ROOT)
endif

THIS_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

PROFILE := x86-gcc-limited-libc
PROFILE_DIR := $(realpath $(THIS_DIR)/../profiles)/$(PROFILE)

default:
	@echo $(PROFILE_DIR)

ifeq ($(strip $(BUILD_DIR)),)
  $(error Need BUILD_DIR)
endif
B := $(BUILD_DIR)

# We can use:
# * user provided K ($(USER_LLVM_PATH))
# * cached K ($(CACHED_LLVM_PATH))
# * custom build K $(OUR_LLVM_PATH)

# OUR_LLVM_PATH
# Our Clang.

CLANG_VERSION := 3.9.1
CLANG_ARCHITECTURE := x86_64-linux-gnu-ubuntu-16.04
CLANG_DIR := clang+llvm-$(CLANG_VERSION)-$(CLANG_ARCHITECTURE)
CLANG_ARCHIVE := $(CLANG_DIR).tar.xz
CLANG_URL := http://releases.llvm.org/$(CLANG_VERSION)/$(CLANG_ARCHIVE)

OUR_LLVM_PATH := $(B)/$(CLANG_DIR)

# USER_LLVM_PATH
# User-provided Clang

ifdef LLVM_PATH
  $(info Using user-defined LLVM_PATH:)
  $(info LLVM_PATH=$(LLVM_PATH))
  ifeq (,$(wildcard $(LLVM_PATH)/bin/clang))
    $(error No 'clang' in user-provided LLVM_PATH)
  endif
  USER_LLVM_PATH := $(LLVM_PATH)
endif

# CACHED_LLVM_PATH
# Clang from deps.mk

ifeq (,$(wildcard $(B)/deps.mk))
  CACHED_LLVM_PATH :=
else
  include $(B)/deps.mk
  CACHED_LLVM_PATH := $(LLVM_PATH)
endif

#TODO use lists
ifneq (,$(strip $(USER_LLVM_PATH)))
  DESIRED_LLVM_PATH := $(USER_LLVM_PATH)
else
  ifneq (,$(strip $(CACHED_LLVM_PATH)))
    DESIRED_LLVM_PATH := $(CACHED_LLVM_PATH)
  else
    DESIRED_LLVM_PATH := $(OUR_LLVM_PATH)
  endif
endif


.PHONY: default
default: regenerate

$(OUR_LLVM_PATH): # $(B)/$(CLANG_ARCHIVE)
	@wget -O '$(B)/$(CLANG_ARCHIVE)' '$(CLANG_URL)'
	@cd $(B); tar -xJf '$(B)/$(CLANG_ARCHIVE)'

.PHONY: regenerate
regenerate: $(DESIRED_LLVM_PATH)
	@rm -f $(B)/deps.mk
	@echo 'LLVM_PATH := $(DESIRED_LLVM_PATH)' >> $(B)/deps.mk


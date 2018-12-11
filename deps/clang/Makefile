ifeq ($(strip $(BUILD_DIR)),)
  $(error Need BUILD_DIR)
endif
$(info BUILD_DIR: $(BUILD_DIR))
B := $(BUILD_DIR)

ifeq ($(strip $(LLVM_PATH)),)
  $(info Need to download clang)
  WORK_TO_DO := obtain-clang
endif

default:
	@echo "Obtaining clang"
	@echo "LLVM_PATH: $(LLVM_PATH)"
	@touch $(B)/deps.mk


.PHONY: obtain-clang
obtain-clang:


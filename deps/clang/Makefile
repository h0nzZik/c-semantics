ifeq ($(strip $(BUILD_DIR)),)
  $(error Need BUILD_DIR)
endif
$(info BUILD_DIR: $(BUILD_DIR))
B := $(BUILD_DIR)

default:
	@echo "Obtaining clang"
	@echo "LLVM_PATH: $(LLVM_PATH)"
	@touch $(B)/deps.mk

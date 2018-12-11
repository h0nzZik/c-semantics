ifeq ($(strip $(BUILD_DIR)),)
  $(error Need BUILD_DIR)
endif
$(info BUILD_DIR: $(BUILD_DIR))
B := $(BUILD_DIR)

default:
	@echo "Obtaining K"
	@echo "K_BIN: $(K_BIN)"
	@touch $(B)/deps.mk

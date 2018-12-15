ifeq ($(strip $(BUILD_DIR)),)
  $(error Need BUILD_DIR)
endif

ifeq ($(strip $(BUILD_ROOT)),)
  $(error Need BUILD_ROOT)
endif

B := $(BUILD_DIR)

GENERATING = echo Creating $(@:$(BUILD_ROOT)/%=%)

include $(BUILD_ROOT)/deps/deps.mk

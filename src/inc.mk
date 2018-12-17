ifeq ($(strip $(BUILD_DIR)),)
  $(error Need BUILD_DIR)
endif

ifeq ($(strip $(BUILD_ROOT)),)
  $(error Need BUILD_ROOT)
endif

ifeq ($(strip $(DIST_ROOT)),)
  $(error Need DIST_ROOT)
endif

B := $(BUILD_DIR)

GENERATING = echo Creating $(@:$(BUILD_ROOT)/%=%)
ECHO_OPEN  = echo "<  Building $@ >"
ECHO_CLOSE = echo "</ Finished $@ >"

include $(BUILD_ROOT)/deps/deps.mk

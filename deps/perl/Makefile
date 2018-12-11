ifeq ($(strip $(BUILD_DIR)),)
  $(error Need BUILD_DIR)
endif
$(info BUILD_DIR: $(BUILD_DIR))
B := $(BUILD_DIR)

.PHONY:
default: $(B)/deps.mk

$(B)/deps.mk: checkForModules.pl
	@echo "Checking for Perl dependencies"
	@perl $<
	@touch $@


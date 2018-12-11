ifeq ($(strip $(BUILD_DIR)),)
  $(error Need BUILD_DIR)
endif
B := $(BUILD_DIR)

.PHONY:
default: $(B)/deps.mk

$(B)/deps.mk: checkForModules.pl
	@echo "Checking for Perl dependencies"
	@perl $<
	@touch $@


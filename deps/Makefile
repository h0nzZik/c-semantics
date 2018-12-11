ifeq ($(strip $(BUILD_DIR)),)
  $(error Need BUILD_DIR)
endif

B := $(BUILD_DIR)/deps

DEPS := cdecl clang k perl

.PHONY: default
default: $(DEPS)

.PHONY: $(DEPS)
$(DEPS):
	@echo "< Building dependency '$@'>"
	mkdir -p $(B)/$@
	$(MAKE) -C $@ BUILD_DIR=$(B)/$@
	@echo "</Building dependency '$@'>"


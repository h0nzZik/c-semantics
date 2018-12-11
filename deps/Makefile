ifeq ($(strip $(BUILD_DIR)),)
  $(error Need BUILD_DIR)
endif

B := $(BUILD_DIR)

DEPS := cdecl clang k perl

.PHONY: default
default: $(B)/deps.mk $(DEPS)

.PHONY: $(DEPS)
$(DEPS):
	@echo "< Building dependency '$@'>"
	mkdir -p $(B)/$@
	$(MAKE) -C $@ BUILD_DIR=$(B)/$@
	@echo "</Building dependency '$@'>"

$(B)/deps.mk:
	@rm -f $@
	@echo $(DEPS)
	@cp deps.mk $@
	@for d in $(DEPS); do echo include $$d/deps.mk >> $@; done

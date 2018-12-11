ifeq ($(strip $(BUILD_DIR)),)
  $(error Need BUILD_DIR)
endif

B := $(BUILD_DIR)

DEPS := cdecl clang k perl

#TODO: ocaml, gcc/clang
#let's deal with ocaml in the K directory, since we need it only
#when working 

.PHONY: default
default: regenerate $(DEPS)

.PHONY: $(DEPS)
$(DEPS):
	@echo "< Building dependency '$@'>"
	mkdir -p $(B)/$@
	$(MAKE) -C $@ BUILD_DIR=$(B)/$@
	@echo "</Building dependency '$@'>"

regenerate:
	@rm -f $(B)/deps.mk
	@echo $(DEPS)
	@cp deps.mk $(B)/deps.mk
	@for d in $(DEPS); do echo include '$$(BUILD_ROOT)/deps'/$$d/deps.mk >> $(B)/deps.mk; done

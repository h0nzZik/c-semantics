ifeq ($(strip $(BUILD_DIR)),)
  $(error Need BUILD_DIR)
endif

default:

include cdecl/Makefile
include clang/Makefile
include k/Makefile
include perl/Makefile

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

$(BUILD_DIR)/deps.mk: FORCE
	@rm -f $@
	@echo $(DEPS)
	@cp deps.mk $@
	@for d in $(DEPS); do echo include '$$(BUILD_ROOT)/deps'/$$d/deps.mk >> $@; done


FORCE:

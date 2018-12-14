ifeq ($(strip $(BUILD_DIR)),)
  $(error Need BUILD_DIR)
endif

B := $(BUILD_DIR)

SRCS := clang-tools cparser native-server kcc semantics

.PHONY: default
default: $(SRCS)

.PHONY: help
help:
	@echo Targets: $(SRCS)

.PHONY: $(SRCS)
$(SRCS):
	@echo "< Building project '$@'>"
	@mkdir -p $(B)/$@
	@$(MAKE) -C $@ BUILD_DIR=$(B)/$@
	@echo "</Building project '$@'>"


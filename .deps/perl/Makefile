ifeq ($(strip $(BUILD_DIR)),)
  $(error Need BUILD_DIR)
endif
B := $(BUILD_DIR)

.PHONY: default
default: deps regenerate

BUILD_LOCAL_PERL := $(B)/local
CPANM_EXECUTABLE := $(B)/cpanm

include deps.mk

$(CPANM_EXECUTABLE):
	wget -O $@ 'http://cpanmin.us/'
	chmod +x $@
	mkdir -p $@.dir

PERL_MODULES :=
PERL_MODULES += Getopt::Declare
PERL_MODULES += String::Escape
PERL_MODULES += String::ShellQuote
PERL_MODULES += App::FatPacker
PERL_MODULES += UUID::Tiny

.PHONY: deps
deps: $(CPANM_EXECUTABLE)
	@$(CPANM) $(PERL_MODULES)

.PHONY: regenerate
regenerate: $(CPANM_EXECUTABLE)
	@rm -f $(B)/deps.mk
	@echo 'CPANM_EXECUTABLE := $(CPANM_EXECUTABLE)' >> $(B)/deps.mk
	@echo 'BUILD_LOCAL_PERL := $(BUILD_LOCAL_PERL)' >> $(B)/deps.mk
	@cat deps.mk >> $(B)/deps.mk




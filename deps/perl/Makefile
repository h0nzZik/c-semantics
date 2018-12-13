ifeq ($(strip $(BUILD_DIR)),)
  $(error Need BUILD_DIR)
endif
B := $(BUILD_DIR)

.PHONY: default
default: regenerate

#$(B)/deps.mk: checkForModules.pl
#	@echo "Checking for Perl dependencies"
#	@perl $<
#	@touch $@

CPANM := $(B)/cpanm
$(CPANM):
	wget -O $@ 'http://cpanmin.us/'
	chmod +x $@
	mkdir -p $@.dir

.PHONY: regenerate
regenerate: $(CPANM)
	@rm -f $(B)/deps.mk
	@echo 'CPANM_EXECUTABLE := $(CPANM)' >> $(B)/deps.mk
	@echo 'PERL_LOCAL := $(B)/local' >> $(B)/deps.mk
	@echo 'CPANM := $$(CPANM_EXECUTABLE) --local-lib=$$(PERL_LOCAL)' >> $(B)/deps.mk




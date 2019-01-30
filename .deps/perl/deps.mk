CPANM := $(CPANM_EXECUTABLE) --self-contained --local-lib=$(BUILD_LOCAL_PERL)
export PERL5LIB := $(BUILD_LOCAL_PERL)/lib/perl5:$(PERL5LIB)

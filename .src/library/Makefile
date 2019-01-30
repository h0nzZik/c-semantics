include ../inc.mk

ifeq ($(strip $(KCC)),)
  $(error KCC not defined)
endif

ifeq ($(strip $(PROFILE)),)
  $(error PROFILE not defined)
endif

ifeq ($(strip $(SUBPROFILE_DIRS)),)
  export SUBPROFILE_DIRS =
endif

.PHONY: default
default: $(B)/libc.so $(B)/libstdc++.so
	@echo Hi

KCCFLAGS := -D_POSIX_C_SOURCE=200809 -nodefaultlibs -fno-native-compilation

LIBC_SRC := $(wildcard $(PROFILE_DIR)/src/*.c) $(foreach d,$(SUBPROFILE_DIRS),$(wildcard $(d)/src/*.c))

$(B)/libc.so: $(LIBC_SRC)
	@$(GENERATING)
	@cd $(PROFILE_DIR)/src && $(KCC) --use-profile $(PROFILE) -shared -o $@ *.c $(KCCFLAGS) -I .
	@$(foreach d,$(SUBPROFILE_DIRS), \
		cd $(d)/src && $(KCC) --use-profile $(shell basename $(d)) -shared -o $(shell pwd)/dist/profiles/$(shell basename $(d))/lib/libc.so *.c $(KCCFLAGS) -I .)



LIBSTDCXX_SRC := $(wildcard $(PROFILE_DIR)/compiler-src/*.C) $(foreach d,$(SUBPROFILE_DIRS),$(wildcard $(d)/compiler-src/*))

LIBSTDCXX := $(B)/libstdc++.so
$(LIBSTDCXX): $(LIBSTDCXX_SRC)
	@$(GENERATING)
	@cd $(PROFILE_DIR)/compiler-src && $(KCC) --use-profile $(PROFILE) -shared -o $@ *.C $(KCCFLAGS) -I .
	@$(foreach d,$(SUBPROFILE_DIRS), \
		cd $(d)/compiler-src && \
		$(KCC) --use-profile $(shell basename $(d)) -shared -o $(shell pwd)/dist/profiles/$(shell basename $(d))/lib/libstdc++.so *.C $(KCCFLAGS) -I .;)



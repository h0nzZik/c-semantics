ifeq ($(strip $(BUILD_DIR)),)
  $(error Need BUILD_DIR)
endif
B := $(BUILD_DIR)

default: $(B)/cdecl-3.6/src/cdecl
	@touch $(B)/deps.mk


$(B)/cdecl-%/src/cdecl: cdecl-%.tar.gz
	@echo "Building cdecl"
	cp $< $(B)
	flock -w 120 $(B)/$< sh -c 'cd $(B) && tar xvf cdecl-$*.tar.gz && cd cdecl-$* && ./configure --without-readline && $(MAKE)' || true


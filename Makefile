SEMANTICS_DIR = semantics
SCRIPTS_DIR = scripts
PARSER_DIR = parser
CPPPARSER_DIR = clang-tools
export PROFILE_DIR = $(shell pwd)/x86-gcc-limited-libc
export PROFILE = $(shell basename $(PROFILE_DIR))
export SUBPROFILE_DIRS =
TESTS_DIR = tests
PARSER = $(PARSER_DIR)/cparser
DIST_DIR = dist
KCCFLAGS = 
PASS_TESTS_DIR = tests/unit-pass
FAIL_TESTS_DIR = tests/unit-fail
FAIL_COMPILE_TESTS_DIR = tests/unit-fail-compilation

FILES_TO_DIST = \
	$(SCRIPTS_DIR)/k++ \
	$(SCRIPTS_DIR)/kranlib \
	$(SCRIPTS_DIR)/merge-kcc-obj \
	$(SCRIPTS_DIR)/split-kcc-obj \
	$(SCRIPTS_DIR)/make-trampolines \
	$(SCRIPTS_DIR)/make-symbols \
	$(SCRIPTS_DIR)/gccsymdump \
	$(SCRIPTS_DIR)/globalize-syms \
	$(SCRIPTS_DIR)/ignored-flags \
	$(SCRIPTS_DIR)/program-runner \
	$(SCRIPTS_DIR)/histogram-csv \
	$(PARSER_DIR)/cparser \
	$(CPPPARSER_DIR)/clang-kast \
	$(CPPPARSER_DIR)/call-sites \
	$(SCRIPTS_DIR)/cdecl-3.6/src/cdecl \
	LICENSE \
	licenses

LIBC_SO = $(DIST_DIR)/$(PROFILE)/lib/libc.so
LIBSTDCXX_SO = $(DIST_DIR)/$(PROFILE)/lib/libstdc++.so

define timestamp_of
    $(DIST_DIR)/$(PROFILE)/$(1)-kompiled/$(1)-kompiled/timestamp
endef

.PHONY: default check-vars semantics clean fast cpp-semantics translation-semantics execution-semantics $(DIST_DIR) test-build pass fail fail-compile parser/cparser $(CPPPARSER_DIR)/clang-kast native-server

default: test-build

fast: $(LIBC_SO) $(LIBSTDCXX_SO) $(call timestamp_of,c11-cpp14)

check-vars:
	@if ! ocaml -version > /dev/null 2>&1; then echo "ERROR: You don't seem to have ocaml installed.  You need to install this before continuing.  Please see INSTALL.md for more information."; false; fi
	@if ! gcc -v > /dev/null 2>&1; then if ! clang -v > /dev/null 2>&1; then echo "ERROR: You don't seem to have gcc or clang installed.  You need to install this before continuing.  Please see INSTALL.md for more information."; false; fi fi
	@if ! kompile --version > /dev/null 2>&1; then echo "ERROR: You don't seem to have kompile installed.  You need to install this before continuing.  Please see INSTALL.md for more information."; false; fi
	@if ! krun --version > /dev/null 2>&1; then echo "ERROR: You don't seem to have krun installed.  You need to install this before continuing.  Please see INSTALL.md for more information."; false; fi
	@perl $(SCRIPTS_DIR)/checkForModules.pl

$(DIST_DIR)/kcc: $(SCRIPTS_DIR)/kcc $(FILES_TO_DIST) $(wildcard $(PROFILE_DIR)/include/* $(PROFILE_DIR)/pp $(PROFILE_DIR)/cpp-pp) $(foreach d,$(SUBPROFILE_DIRS),$(wildcard $(d)/include/*) $(d)/pp $(d)/cpp-pp) native-server | check-vars
	@mkdir -p $(DIST_DIR)
	@mkdir -p $(DIST_DIR)/$(PROFILE)/lib
	@printf "%s" $(PROFILE) > $(DIST_DIR)/current-profile
	@printf "%s" $(PROFILE) > $(DIST_DIR)/default-profile
	@cp -Lp $(PROFILE_DIR)/pp $(DIST_DIR)/$(PROFILE)
	@-cp -Lp $(PROFILE_DIR)/cpp-pp $(DIST_DIR)/$(PROFILE)
	@cp -RLp $(PROFILE_DIR)/include $(DIST_DIR)/$(PROFILE)
	@cp -RLp $(PROFILE_DIR)/src $(DIST_DIR)/$(PROFILE)
	@cp -RLp $(PROFILE_DIR)/native $(DIST_DIR)/$(PROFILE)
	@cp -RLp $(PROFILE_DIR)/compiler-src $(DIST_DIR)/$(PROFILE)
	@$(foreach d,$(SUBPROFILE_DIRS), \
		mkdir -p $(DIST_DIR)/$(shell basename $(d))/lib)
	@$(foreach d,$(SUBPROFILE_DIRS), \
		cp -Lp $(d)/pp $(DIST_DIR)/$(shell basename $(d)))
	@-$(foreach d,$(SUBPROFILE_DIRS), \
		cp -Lp $(d)/cpp-pp $(DIST_DIR)/$(shell basename $(d)))
	@$(foreach d,$(SUBPROFILE_DIRS), \
		cp -RLp $(d)/include $(DIST_DIR)/$(shell basename $(d)))
	@$(foreach d,$(SUBPROFILE_DIRS), \
		cp -RLp $(d)/src $(DIST_DIR)/$(shell basename $(d)))
	@$(foreach d,$(SUBPROFILE_DIRS), \
		cp -RLp $(d)/native $(DIST_DIR)/$(shell basename $(d)))
	@$(foreach d,$(SUBPROFILE_DIRS), \
		cp -RLp $(d)/compiler-src $(DIST_DIR)/$(shell basename $(d)))
	@cp -RLp $(FILES_TO_DIST) $(DIST_DIR)
	@cat $(SCRIPTS_DIR)/kcc | perl $(SCRIPTS_DIR)/getopt.pl > $(DIST_DIR)/kcc
	@chmod --reference=$(SCRIPTS_DIR)/kcc $(DIST_DIR)/kcc
	@$(CC) $(SCRIPTS_DIR)/writelong.c -o $(DIST_DIR)/writelong
	@cp -p $(SCRIPTS_DIR)/kcc $(DIST_DIR)/kclang

$(PROFILE_DIR)/cpp-pp:

$(call timestamp_of,c11-cpp14):         execution-semantics $(DIST_DIR)/$(PROFILE)/c11-cpp14-kompiled
$(call timestamp_of,c11-translation):   translation-semantics $(DIST_DIR)/$(PROFILE)/c11-translation-kompiled
$(call timestamp_of,cpp14-translation): cpp-semantics $(DIST_DIR)/$(PROFILE)/cpp14-translation-kompiled
$(call timestamp_of,c11-nd):            semantics $(DIST_DIR)/$(PROFILE)/c11-nd-kompiled
$(call timestamp_of,c11-nd-thread):     semantics $(DIST_DIR)/$(PROFILE)/c11-nd-thread-kompiled

$(DIST_DIR)/$(PROFILE)/%-kompiled: $(DIST_DIR)/kcc
	@cp -p -RL $(SEMANTICS_DIR)/$(PROFILE)/$(*)-kompiled $(DIST_DIR)/$(PROFILE)
	@$(foreach d,$(SUBPROFILE_DIRS), \
		cp -RLp $(SEMANTICS_DIR)/$(PROFILE)/$(*)-kompiled $(DIST_DIR)/$(shell basename $(d)))

$(LIBSTDCXX_SO): $(call timestamp_of,cpp14-translation) $(wildcard $(PROFILE_DIR)/compiler-src/*.C) $(foreach d,$(SUBPROFILE_DIRS),$(wildcard $(d)/compiler-src/*)) $(DIST_DIR)/kcc
	@echo "Translating the C++ standard library... ($(PROFILE_DIR))"
	cd $(PROFILE_DIR)/compiler-src && $(shell pwd)/$(DIST_DIR)/kcc -nodefaultlibs -Xbuiltins -fno-native-compilation -fnative-binary -shared -o $(shell pwd)/$(LIBSTDCXX_SO) *.C $(KCCFLAGS) -I .
	@$(foreach d,$(SUBPROFILE_DIRS), \
		$(shell pwd)/$(DIST_DIR)/kcc -profile $(shell basename $(d)) && \
		cd $(d)/compiler-src && \
		$(shell pwd)/$(DIST_DIR)/kcc -nodefaultlibs -Xbuiltins -fno-native-compilation -fnative-binary -shared -o $(shell pwd)/$(DIST_DIR)/$(shell basename $(d))/lib/libstdc++.so *.C $(KCCFLAGS) -I .)
	@$(shell pwd)/$(DIST_DIR)/kcc -profile $(PROFILE)
	@echo "Done."

$(LIBC_SO): $(call timestamp_of,cpp14-translation) $(call timestamp_of,c11-translation) $(wildcard $(PROFILE_DIR)/native/*.c) $(wildcard $(PROFILE_DIR)/src/*.c) $(foreach d,$(SUBPROFILE_DIRS),$(wildcard $(d)/native/*.c)) $(foreach d,$(SUBPROFILE_DIRS),$(wildcard $(d)/src/*.c)) $(DIST_DIR)/kcc
	@echo "Translating the C standard library... ($(PROFILE_DIR))"
	cd $(PROFILE_DIR)/native && $(CC) -c *.c -I .
	cd $(PROFILE_DIR)/src && $(shell pwd)/$(DIST_DIR)/kcc -nodefaultlibs -Xbuiltins -fno-native-compilation -fnative-binary -shared -o $(shell pwd)/$(LIBC_SO) *.c $(PROFILE_DIR)/native/*.o $(KCCFLAGS) -I .
	@$(foreach d,$(SUBPROFILE_DIRS), \
		echo "Translating the C standard library... ($(d))" && \
		$(shell pwd)/$(DIST_DIR)/kcc -profile $(shell basename $(d)) && \
		cd $(d)/native && \
		$(CC) -c *.c -I . && \
		cd $(d)/src && \
		$(shell pwd)/$(DIST_DIR)/kcc -nodefaultlibs -Xbuiltins -fno-native-compilation -fnative-binary -shared -o $(shell pwd)/$(DIST_DIR)/$(shell basename $(d))/lib/libc.so *.c $(d)/native/*.o $(KCCFLAGS) -I .)

native-server: $(DIST_DIR)/$(PROFILE)/native-server/main.o $(DIST_DIR)/$(PROFILE)/native-server/server.c $(DIST_DIR)/$(PROFILE)/native-server/platform.o $(DIST_DIR)/$(PROFILE)/native-server/platform.h $(DIST_DIR)/$(PROFILE)/native-server/server.h

$(DIST_DIR)/$(PROFILE)/native-server/main.o: native-server/main.c native-server/server.h
	mkdir -p $(dir $@)
	gcc -c $< -o $@ -Wall -Wextra -pedantic -Werror -g
$(DIST_DIR)/$(PROFILE)/native-server/%.h: native-server/%.h
	mkdir -p $(dir $@)
	cp -RLp $< $@
$(DIST_DIR)/$(PROFILE)/native-server/server.c: native-server/server.c
	mkdir -p $(dir $@)
	cp -RLp $< $@
$(DIST_DIR)/$(PROFILE)/native-server/platform.o: $(PROFILE_DIR)/native-server/platform.c native-server/platform.h
	mkdir -p $(dir $@)
	gcc -c $< -o $@ -Wall -Wextra -pedantic -Werror -I native-server -g

test-build: fast
	@echo "Testing kcc..."
	printf "#include <stdio.h>\nint main(void) {printf(\"x\"); return 42;}\n" | $(DIST_DIR)/kcc -x c - -o $(DIST_DIR)/testProgram.compiled
	$(DIST_DIR)/testProgram.compiled 2> /dev/null > $(DIST_DIR)/testProgram.out; test $$? -eq 42
	grep x $(DIST_DIR)/testProgram.out > /dev/null
	@echo "Done."
	@echo "Cleaning up..."
	@rm -f $(DIST_DIR)/testProgram.compiled
	@rm -f $(DIST_DIR)/testProgram.out
	@echo "Done."

parser/cparser:
	@echo "Building the C parser..."
	@$(MAKE) -C $(PARSER_DIR)

$(CPPPARSER_DIR)/call-sites: $(CPPPARSER_DIR)/clang-kast

$(CPPPARSER_DIR)/clang-kast:
	@echo "Building the C++ parser..."
	@cd $(CPPPARSER_DIR) && cmake .
	@$(MAKE) -C $(CPPPARSER_DIR)

scripts/cdecl-%/src/cdecl: scripts/cdecl-%.tar.gz
	flock -n $< sh -c 'cd scripts && tar xvf cdecl-$*.tar.gz && cd cdecl-$* && ./configure --without-readline && $(MAKE)' || true

translation-semantics: check-vars 
	@$(MAKE) -C $(SEMANTICS_DIR) translation

execution-semantics: check-vars
	@$(MAKE) -C $(SEMANTICS_DIR) execution

cpp-semantics: check-vars
	@$(MAKE) -C $(SEMANTICS_DIR) cpp

semantics: check-vars
	@$(MAKE) -C $(SEMANTICS_DIR) all

check:	pass fail fail-compile

pass:	test-build
	@$(MAKE) -C $(PASS_TESTS_DIR) c-comparison

fail:	test-build
	@$(MAKE) -C $(FAIL_TESTS_DIR) c-comparison

fail-compile:	test-build
	@$(MAKE) -C $(FAIL_COMPILE_TESTS_DIR) c-comparison

clean:
	-$(MAKE) -C $(PARSER_DIR) clean
	-$(MAKE) -C $(CPPPARSER_DIR) clean
	-$(MAKE) -C $(SEMANTICS_DIR) clean
	-$(MAKE) -C $(TESTS_DIR) clean
	-$(MAKE) -C $(PASS_TESTS_DIR) clean
	-$(MAKE) -C $(FAIL_TESTS_DIR) clean
	-$(MAKE) -C $(FAIL_COMPILE_TESTS_DIR) clean
	@-rm -rf $(DIST_DIR)
	@-rm -f ./*.tmp ./*.log ./*.cil ./*-gen.maude ./*.gen.maude ./*.pre.gen ./*.prepre.gen ./a.out ./*.kdump ./*.pre.pre 

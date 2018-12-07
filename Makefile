include $(dir $(lastword $(MAKEFILE_LIST)))/.build/inc.mk

export PROFILE_DIR = $(shell pwd)/profiles/x86-gcc-limited-libc
export PROFILE = $(shell basename $(PROFILE_DIR))
export SUBPROFILE_DIRS =
PARSER = $(CPARSER_DIR)/cparser
KCCFLAGS = -D_POSIX_C_SOURCE=200809 -nodefaultlibs -fno-native-compilation
CFLAGS = -std=gnu11 -Wall -Wextra -Werror -pedantic

FILES_TO_DIST = \
	scripts/kcc \
	scripts/k++ \
	scripts/kranlib \
	scripts/merge-kcc-obj \
	scripts/split-kcc-obj \
	scripts/make-trampolines \
	scripts/make-symbols \
	scripts/gccsymdump \
	scripts/globalize-syms \
	scripts/ignored-flags \
	scripts/program-runner \
	scripts/histogram-csv \
	scripts/cdecl-3.6/src/cdecl \
	scripts/cparser \
	scripts/clang-kast \
	scripts/call-sites \
	LICENSE \
	licenses

PROFILE_FILES = include src compiler-src native pp cpp-pp cc cxx
PROFILE_FILE_DEPS = $(foreach f, $(PROFILE_FILES), $(PROFILE_DIR)/$(f))
SUBPROFILE_FILE_DEPS = $(foreach d, $(SUBPROFILE_DIRS), $(foreach f, $(PROFILE_FILES), $(d)/$(f)))

PERL_MODULES = \
	scripts/RV_Kcc/Opts.pm \
	scripts/RV_Kcc/Files.pm \
	scripts/RV_Kcc/Shell.pm

DIST_PROFILES = dist/profiles
LIBC_SO = $(DIST_PROFILES)/$(PROFILE)/lib/libc.so
LIBSTDCXX_SO = $(DIST_PROFILES)/$(PROFILE)/lib/libstdc++.so

define timestamp_of
    dist/profiles/$(PROFILE)/$(1)-kompiled/$(1)-kompiled/timestamp
endef

.PHONY: default
default: kcc-sanity-check

.PHONY: help
help:
	@echo "Available targets:"
	@echo "  clean"
	@echo "  prune"


dist/writelong: scripts/writelong.c
	@mkdir -p $(dir $@)
	@gcc $(CFLAGS) $< -o $@

dist/RV_Kcc/Opts.pm: scripts/RV_Kcc/Opts.pm scripts/getopt.pl
	@echo Building "$@"
	@mkdir -p $(dir $@)
	@cat $< | perl scripts/getopt.pl > $@


dist/kcc: dist/RV_Kcc/Opts.pm $(PERL_MODULES) dist/writelong $(FILES_TO_DIST) 
	@echo Building 'kcc'
	@mkdir -p dist/RV_Kcc
	cp -RLp $(FILES_TO_DIST) dist
	cp -RLp $(PERL_MODULES) dist/RV_Kcc
	cp -p dist/kcc dist/kclang

.PHONY: pack
pack: dist/kcc
	@echo Packing 'kcc'
	@cd dist && fatpack trace kcc
	@cd dist && fatpack packlists-for `cat fatpacker.trace` >packlists
	@cat dist/packlists
	@cd dist && fatpack tree `cat packlists`
	@cp -rf dist/RV_Kcc dist/fatlib
	@cd dist && fatpack file kcc > kcc.packed
	@chmod --reference=dist/kcc dist/kcc.packed
	@mv -f dist/kcc.packed dist/kcc
	@cp -pf dist/kcc dist/kclang
	@rm -rf dist/fatlib dist/RV_Kcc dist/packlists dist/fatpacker.trace

$(DIST_PROFILES)/$(PROFILE): dist/kcc $(PROFILE_FILE_DEPS) $(SUBPROFILE_FILE_DEPS) $(PROFILE)-native | dependencies
	@mkdir -p $@/lib
	@printf "%s" $(PROFILE) > dist/current-profile
	@printf "%s" $(PROFILE) > dist/default-profile
	@-$(foreach f, $(PROFILE_FILE_DEPS), \
		cp -RLp $(f) $(DIST_PROFILES)/$(PROFILE);)
	@$(foreach d, $(SUBPROFILE_DIRS), \
		mkdir -p $(DIST_PROFILES)/$(shell basename $(d))/lib;)
	@-$(foreach d, $(SUBPROFILE_DIRS), $(foreach f, $(PROFILE_FILES), \
		cp -RLp $(d)/$(f) $(DIST_PROFILES)/$(shell basename $(d))/$(f);))
	@-$(foreach d, $(SUBPROFILE_DIRS), \
		cp -RLp $(DIST_PROFILES)/$(PROFILE)/native/* $(DIST_PROFILES)/$(shell basename $(d))/native;)

$(call timestamp_of,c-cpp): execution-semantics $(DIST_PROFILES)/$(PROFILE)
	@cp -p -RL $(SEMANTICS_DIR)/.build/$(PROFILE)/c-cpp-kompiled $(DIST_PROFILES)/$(PROFILE)
	@$(foreach d,$(SUBPROFILE_DIRS), \
		cp -RLp $(SEMANTICS_DIR)/.build/$(PROFILE)/c-cpp-kompiled $(DIST_PROFILES)/$(shell basename $(d));)

$(call timestamp_of,c-cpp-linking): linking-semantics $(DIST_PROFILES)/$(PROFILE)
	@cp -p -RL $(SEMANTICS_DIR)/.build/$(PROFILE)/c-cpp-linking-kompiled $(DIST_PROFILES)/$(PROFILE)
	@$(foreach d,$(SUBPROFILE_DIRS), \
		cp -RLp $(SEMANTICS_DIR)/.build/$(PROFILE)/c-cpp-linking-kompiled $(DIST_PROFILES)/$(shell basename $(d));)

$(call timestamp_of,c-translation): translation-semantics $(DIST_PROFILES)/$(PROFILE)
	@cp -p -RL $(SEMANTICS_DIR)/.build/$(PROFILE)/c-translation-kompiled $(DIST_PROFILES)/$(PROFILE)
	@$(foreach d,$(SUBPROFILE_DIRS), \
		cp -RLp $(SEMANTICS_DIR)/.build/$(PROFILE)/c-translation-kompiled $(DIST_PROFILES)/$(shell basename $(d));)

$(call timestamp_of,cpp-translation): cpp-semantics $(DIST_PROFILES)/$(PROFILE)
	@cp -p -RL $(SEMANTICS_DIR)/.build/$(PROFILE)/cpp-translation-kompiled $(DIST_PROFILES)/$(PROFILE)
	@$(foreach d,$(SUBPROFILE_DIRS), \
		cp -RLp $(SEMANTICS_DIR)/.build/$(PROFILE)/cpp-translation-kompiled $(DIST_PROFILES)/$(shell basename $(d));)

$(LIBSTDCXX_SO): $(call timestamp_of,c-cpp-linking) $(call timestamp_of,cpp-translation) $(wildcard $(PROFILE_DIR)/compiler-src/*.C) $(foreach d,$(SUBPROFILE_DIRS),$(wildcard $(d)/compiler-src/*)) $(DIST_PROFILES)/$(PROFILE)
	@echo "$(PROFILE): Translating the C++ standard library..."
	@cd $(PROFILE_DIR)/compiler-src && $(shell pwd)/dist/kcc --use-profile $(PROFILE) -shared -o $(shell pwd)/$(LIBSTDCXX_SO) *.C $(KCCFLAGS) -I .
	@$(foreach d,$(SUBPROFILE_DIRS), \
		cd $(d)/compiler-src && \
		$(shell pwd)/dist/kcc --use-profile $(shell basename $(d)) -shared -o $(shell pwd)/$(DIST_PROFILES)/$(shell basename $(d))/lib/libstdc++.so *.C $(KCCFLAGS) -I .;)
	@echo "$(PROFILE): Done translating the C++ standard library."

$(LIBC_SO): $(call timestamp_of,c-cpp-linking) $(call timestamp_of,c-translation) $(wildcard $(PROFILE_DIR)/src/*.c) $(foreach d,$(SUBPROFILE_DIRS),$(wildcard $(d)/src/*.c)) $(DIST_PROFILES)/$(PROFILE)
	@echo "$(PROFILE): Translating the C standard library..."
	@cd $(PROFILE_DIR)/src && $(shell pwd)/dist/kcc --use-profile $(PROFILE) -shared -o $(shell pwd)/$(LIBC_SO) *.c $(KCCFLAGS) -I .
	@$(foreach d,$(SUBPROFILE_DIRS), \
		cd $(d)/src && $(shell pwd)/dist/kcc --use-profile $(shell basename $(d)) -shared -o $(shell pwd)/$(DIST_PROFILES)/$(shell basename $(d))/lib/libc.so *.c $(KCCFLAGS) -I .)
	@echo "$(PROFILE): Done translating the C standard library."

.PHONY: $(PROFILE)-native
$(PROFILE)-native: $(DIST_PROFILES)/$(PROFILE)/native/main.o $(DIST_PROFILES)/$(PROFILE)/native/server.c $(DIST_PROFILES)/$(PROFILE)/native/builtins.o $(DIST_PROFILES)/$(PROFILE)/native/platform.o $(DIST_PROFILES)/$(PROFILE)/native/platform.h $(DIST_PROFILES)/$(PROFILE)/native/server.h

$(DIST_PROFILES)/$(PROFILE)/native/main.o: native-server/main.c native-server/server.h
	mkdir -p $(dir $@)
	gcc $(CFLAGS) -c $< -o $@  -g
$(DIST_PROFILES)/$(PROFILE)/native/%.h: native-server/%.h
	mkdir -p $(dir $@)
	cp -RLp $< $@
$(DIST_PROFILES)/$(PROFILE)/native/server.c: native-server/server.c
	mkdir -p $(dir $@)
	cp -RLp $< $@
$(DIST_PROFILES)/$(PROFILE)/native/%.o: $(PROFILE_DIR)/native/%.c $(wildcard native-server/*.h)
	mkdir -p $(dir $@)
	gcc $(CFLAGS) -c $< -o $@ -I native-server

.PHONY: stdlibs
stdlibs: $(LIBC_SO) $(LIBSTDCXX_SO) $(call timestamp_of,c-cpp)

.PHONY: kcc-sanity-check
kcc-sanity-check: stdlibs
	@echo "Testing kcc..."
	@printf "#include <stdio.h>\nint main(void) {printf(\"x\"); return 42;}\n" | dist/kcc --use-profile $(PROFILE) -x c - -o dist/testProgram.compiled
	dist/testProgram.compiled 2> /dev/null > dist/testProgram.out; test $$? -eq 42
	@grep x dist/testProgram.out > /dev/null
	@echo "Done."
	@echo "Cleaning up..."
	@rm -f dist/testProgram.compiled
	@rm -f dist/testProgram.out
	@echo "Done."

parser/cparser: indenter
	@echo "Building the C parser..."
	@$(MAKE) --no-print-directory -C $(CPARSER_DIR) | $(indenter)

clang-tools/call-sites: clang-tools/clang-kast

.PHONY: clang-tools/clang-kast
clang-tools/clang-kast: clang-tools/Makefile
	@echo "Building the C++ parser..."
	@$(MAKE) --no-print-directory -C clang-tools | $(indenter)

clang-tools/Makefile:
	@cd clang-tools && cmake . | $(indent)

scripts/cdecl-%/src/cdecl: scripts/cdecl-%.tar.gz
	@echo "Building cdecl"
	@flock -w 120 $< sh -c 'cd scripts && tar xvf cdecl-$*.tar.gz && cd cdecl-$* && ./configure --without-readline && $(MAKE)' || true

SOME_SEMANTICS = cpp-semantics linking-semantics translation-semantics execution-semantics all-semantics
.PHONY: $(SOME_SEMANTICS)
$(SOME_SEMANTICS): dependencies
	@echo "Entering './semantics' to build $@"
	@$(MAKE) --no-print-directory -C ./semantics $(@:%-semantics=%) | $(indent)

.PHONY: semantics
semantics: all-semantics

check: test-pass test-fail test-fail-compilation

PASS_TESTS_DIR = tests/unit-pass
FAIL_TESTS_DIR = tests/unit-fail
FAIL_COMPILE_TESTS_DIR = tests/unit-fail-compilation

.PHONY: test-pass test-fail test-fail-compilation
test-%: kcc-sanity-check
	$(eval DIR := tests/unit-$(@:test-%=%))
	@$(MAKE) --no-print-directory -C $(DIR) comparison | $(indent)


# TODO Ensure nobody uses these aliases
# and remove them. They just make the build
# scripts irregular.
.PHONY: pass fail fail-compile
pass: test-pass
fail: test-fail
fail-compile: test-fail-compilation

# TODO remove this irregularity.
.PHONY: os-check
os-check: kcc-sanity-check
	@$(MAKE) --no-print-directory -C $(PASS_TESTS_DIR) os-comparison | $(indent)

SUBDIRECTORIES = parser clang-tools semantics tests
CLEAN_TARGETS = $(foreach var, $(SUBDIRECTORIES), clean-$(var))

.PHONY: $(CLEAN_TARGETS)
$(CLEAN_TARGETS):
	@echo 'Cleaning $@'
	$(eval DIR := $(@:clean-%=%))
	@if [ -f "$(DIR)/Makefile" ]; then $(MAKE) -C $(DIR) clean; fi

#
.PHONY: clean
clean: $(CLEAN_TARGETS)
	@#TODO this should be in dependencies.mk
	-rm -f $(K_SUBMODULE_DIR)/make.timestamp
	-rm -rf dist
	-rm -f ./*.tmp ./*.log ./*.cil ./*-gen.maude ./*.gen.maude ./*.pre.gen ./*.prepre.gen ./a.out ./*.kdump ./*.pre.pre 

include $(DEPENDENCIES_DIR)/dependencies.mk

#TODO clean should not remove calculate dependencies.
# Or should it? Because 'prune' should do every possible thing.
.PHONY: prune
prune: clean
	@echo 'Not implemented yet, but should delete all dependencies'

#TODO we shold try to download Clang
#TODO do not rely on Make when using CMake. Use cmake --build or something like that.


.PHONY: indenter
indenter: $(SCRIPTS_DIR)/indenter

$(SCRIPTS_DIR)/indenter: $(SCRIPTS_DIR)/indenter.c
	@echo "Building indenter"
	@gcc -std=c99 $< -o $@

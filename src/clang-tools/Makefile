# imports:
# - BUILD_ROOT
# exports:
# - CLANG_KAST
# - CLANG_SITES

CLANG_TOOLS_SRC := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))/src
CLANG_TOOLS_BUILD := $(BUILD_ROOT)/clang-tools
B := $(CLANG_TOOLS_BUILD)

$(B)/CMakeCache.txt:
	@$(GENERATING)
	@mkdir -p $@
	@cmake -DLLVM_PATH='$(LLVM_PATH)' -DCMAKE_CXX_FLAGS=-fno-rtti -B '$(B)' -H '$(CLANG_TOOLS_SRC)'

$(B)/clang-kast $(B)/clang-sites: $(B)/%: $(B)/CMakeCache.txt
	@$(GENERATING)
	@echo Building clang-kast and clang-sites
	@cmake --build '$(B)' --target '$*'

# Exported variables
CLANG_KAST := $(CLANG_TOOLS_BUILD)/clang-kast
CLANG_SITES := $(CLANG_TOOLS_BUILD)/clang-sites

# Clean private variables
undefine B
undefine CLANG_TOOLS_SRC
undefine CLANG_TOOLS_BUILD

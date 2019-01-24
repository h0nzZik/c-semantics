# imports:
# - BUILD_ROOT
# exports:
# - CLANG_KAST
# - CLANG_SITES

CLANG_TOOLS_SRC := $(abspath $(dir $(realpath $(lastword $(MAKEFILE_LIST))))/src)
CLANG_TOOLS_BUILD := $(abspath $(BUILD_ROOT)/clang-tools)
B := $(CLANG_TOOLS_BUILD)

#TODO rename LLVM_PATH to CONFIG_LLVM_PATH

$(B)/CMakeCache.txt: $(CLANG_TOOLS_SRC)/CMakeLists.txt
	@$(GENERATING)
	cmake -DLLVM_PATH=$(LLVM_PATH) -DCMAKE_CXX_FLAGS=-fno-rtti -B$(dir $@) -H$(dir $<)

$(B)/clang-kast $(B)/clang-sites: $(B)/%: $(B)/CMakeCache.txt
	@$(GENERATING)
	@cmake --build $(dir $@) --target $*

# Exported variables
CLANG_KAST := $(CLANG_TOOLS_BUILD)/clang-kast
CLANG_SITES := $(CLANG_TOOLS_BUILD)/clang-sites

# Clean private variables
undefine B
undefine CLANG_TOOLS_SRC
undefine CLANG_TOOLS_BUILD

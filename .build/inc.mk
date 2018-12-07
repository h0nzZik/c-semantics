
C_SEMANTICS_DIR = $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/..)
BUILD_DIR = $(C_SEMANTICS_DIR)/.build

#$(info Path to c-semantics:: $(C_SEMANTICS_DIR))


K_SUBMODULE = $(BUILD_DIR)/k
export K_OPTS := -Xmx8g -Xss32m
export K_BIN ?= $(K_SUBMODULE)/k-distribution/target/release/k/bin
export KOMPILE = $(abspath $(K_BIN)/kompile) -O2
export KDEP = $(abspath $(K_BIN)/kdep)

SEMANTICS_DIR = $(C_SEMANTICS_DIR)/semantics
SCRIPTS_DIR = $(C_SEMANTICS_DIR)/scripts
CPARSER_DIR = $(C_SEMANTICS_DIR)/parser
CLANGTOOLS_DIR = $(C_SEMANTICS_DIR)/clang-tools


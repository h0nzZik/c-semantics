C_SEMANTICS_DIR = $(realpath $(dir $(realpath $(lastword $(MAKEFILE_LIST))))/..)

DEPENDENCIES_DIR = $(C_SEMANTICS_DIR)/.build
CLANGTOOLS_DIR   = $(C_SEMANTICS_DIR)/clang-tools
DIST_DIR         = $(C_SEMANTICS_DIR)/dist
CPARSER_DIR      = $(C_SEMANTICS_DIR)/parser
SEMANTICS_DIR    = $(C_SEMANTICS_DIR)/semantics
SCRIPTS_DIR      = $(C_SEMANTICS_DIR)/scripts
TESTS_DIR        = $(C_SEMANTICS_DIR)/tests


K_SUBMODULE_DIR = $(DEPENDENCIES_DIR)/k


export K_OPTS := -Xmx8g -Xss32m
#export K_BIN ?= $(K_SUBMODULE_DIR)/k-distribution/target/release/k/bin
export K_BIN = $(K_SUBMODULE_DIR)/k-distribution/target/release/k/bin

#$(info K_BIN: $(K_BIN))

export KOMPILE = $(K_BIN)/kompile
export KDEP = $(K_BIN)/kdep


indent = $(SCRIPTS_DIR)/indenter

#$(info kompile: $(KOMPILE))

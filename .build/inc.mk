ifeq (0,${MAKELEVEL})

export C_SEMANTICS_DIR := $(realpath $(dir $(realpath $(lastword $(MAKEFILE_LIST))))/..)

export DEPENDENCIES_DIR := $(C_SEMANTICS_DIR)/.build
export CLANGTOOLS_DIR   := $(C_SEMANTICS_DIR)/clang-tools
export DIST_DIR         := $(C_SEMANTICS_DIR)/dist
export CPARSER_DIR      := $(C_SEMANTICS_DIR)/parser
export SEMANTICS_DIR    := $(C_SEMANTICS_DIR)/semantics
export SCRIPTS_DIR      := $(C_SEMANTICS_DIR)/scripts
export TESTS_DIR        := $(C_SEMANTICS_DIR)/tests


export K_SUBMODULE_DIR := $(DEPENDENCIES_DIR)/k


export K_OPTS := -Xmx8g -Xss32m
#export K_BIN ?= $(K_SUBMODULE_DIR)/k-distribution/target/release/k/bin
export K_BIN := $(K_SUBMODULE_DIR)/k-distribution/target/release/k/bin

#$(info K_BIN: $(K_BIN))

export KOMPILE := $(K_BIN)/kompile
export KDEP := $(K_BIN)/kdep


export indent := $(SCRIPTS_DIR)/indenter

#$(info kompile: $(KOMPILE))

endif # ifeq (0,${MAKELEVEL})

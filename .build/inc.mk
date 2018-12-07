$(info A: $(MAKEFILE_LIST))
$(info B: $(lastword $(MAKEFILE_LIST)))
$(info C: $(realpath $(lastword $(MAKEFILE_LIST))))
$(info D: $(dir $(realpath $(lastword $(MAKEFILE_LIST)))))
$(info E: $(realpath $(dir $(realpath $(lastword $(MAKEFILE_LIST))))/..))

C_SEMANTICS_DIR = $(realpath $(dir $(realpath $(lastword $(MAKEFILE_LIST))))/..)



#$(info Path to c-semantics:: $(C_SEMANTICS_DIR))


K_SUBMODULE = $(C_SEMANTICS_DIR)/.build/k
$(info F: $(K_SUBMODULE))
export K_OPTS := -Xmx8g -Xss32m
#export K_BIN ?= $(K_SUBMODULE)/k-distribution/target/release/k/bin
export K_BIN = $(K_SUBMODULE)/k-distribution/target/release/k/bin

$(info K_BIN: $(K_BIN))

export KOMPILE = $(K_BIN)/kompile -O2
export KDEP = $(K_BIN)/kdep

SEMANTICS_DIR = $(C_SEMANTICS_DIR)/semantics
SCRIPTS_DIR = $(C_SEMANTICS_DIR)/scripts
CPARSER_DIR = $(C_SEMANTICS_DIR)/parser
CLANGTOOLS_DIR = $(C_SEMANTICS_DIR)/clang-tools



$(info kompile: $(KOMPILE))

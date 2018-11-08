#!/bin/bash

# Configuration settings for K and c-semantics

#################
# System settings
#################

# Where to put dependencies
SW_DIR="$HOME/sw"

################
# Clang settings
################

CLANG_VERSION="3.9.1"

# Where to put Clang
CLANG_PATH="$SW_DIR/clang-$CLANG_VERSION"

#############
# K Framework
#############

# The official repository
K_REPO="https://github.com/kframework/k.git"
K_BRANCH="master"

# Where to put K
K_PATH="$SW_DIR/k"

# This should stay the same
K_BIN="$SW_DIR/k/k-distribution/bin"

#################
# C/C++ semantics
#################

C_SEMANTICS_REPO="https://github.com/kframework/c-semantics.git"
C_SEMANTICS_BRANCH="master"

# The main subdirectory in the C_SEMANTICS_REPO.
# For RV-Match, this should be "c-semantics/"
C_SEMANTICS_SUBDIRECTORY="./"




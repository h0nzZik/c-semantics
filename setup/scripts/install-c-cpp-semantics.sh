#!/bin/bash

set -e

source "$SETTINGS"

C_SEMANTICS_DIR="$APP_ROOT/c-semantics"

function grab_c_semantics() {

	if [[ ! -d "$C_SEMANTICS_DIR" ]]; then
		echo "Cloning c-semantics"
		git clone "$C_SEMANTICS_REPO" "$C_SEMANTICS_DIR"
	fi
	pushd "$C_SEMANTICS_DIR"
	git checkout "$C_SEMANTICS_BRANCH"
	popd
}

function build_c_semantics() {
	source "$SCRIPTS/env.sh"
	cd "$C_SEMANTICS_DIR"
	pushd clang-tools
		cmake -DCMAKE_CXX_FLAGS="-fno-rtti" -DLLVM_PATH="$CLANG_PATH" .
	popd
	$CGMEMTIME make
}

grab_c_semantics
build_c_semantics

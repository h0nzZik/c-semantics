#!/bin/bash

set -e

if [[ "$1" == "" ]]; then
	echo "Usage: $0 /path/to/directory"
	exit
fi

DIR="$1"

CLANG_VERSION="3.9.1"
CLANG_DIR="$DIR/clang-$CLANG_VERSION"

function install_clang() {
	echo "Installing Clang"

	# Grab some clang
	CLANG_STRING="clang+llvm-$CLANG_VERSION-x86_64-linux-gnu-ubuntu-16.04"
	wget -q "http://releases.llvm.org/$CLANG_VERSION/$CLANG_STRING.tar.xz"
	tar -xJf "$CLANG_STRING.tar.xz"
	mv "$CLANG_STRING" "$CLANG_DIR"

	# cleanup
	rm "$CLANG_STRING.tar.xz"
}



C_SEMANTICS_DIR="$DIR/c-semantics"
C_SEMANTICS_REPO="https://github.com/kframework/c-semantics.git"
C_SEMANTICS_BRANCH="master"

function install_c_semantics() {
	echo "Cloning c-semantics"
	git clone "$C_SEMANTICS_REPO" "$C_SEMANTICS_DIR"
	cd "$C_SEMANTICS_DIR"
	git checkout "$C_SEMANTICS_BRANCH"
	cd clang-tools
	cmake -DCMAKE_CXX_FLAGS="-fno-rtti" -DLLVM_PATH="$CLANG_DIR"
	cd ..
	make
}

install_clang
install_c_semantics


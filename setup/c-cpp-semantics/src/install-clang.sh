#!/bin/bash

set -e

if [[ "$1" == "" ]]; then
	echo "Usage: $0 /when/to/put/clang"
fi


source "$SETTINGS"

function install_clang() {
	if [[ -d "$CLANG_PATH" ]]; then
		echo "Clang seem to be already installed"
		return
	fi

	echo "Installing Clang"

	# Grab some clang
	CLANG_STRING="clang+llvm-$CLANG_VERSION-x86_64-linux-gnu-ubuntu-16.04"
	wget -q "http://releases.llvm.org/$CLANG_VERSION/$CLANG_STRING.tar.xz"
	tar -xJf "$CLANG_STRING.tar.xz"
	mv "$CLANG_STRING" "$CLANG_PATH"

	# cleanup
	rm "$CLANG_STRING.tar.xz"
}

install_clang

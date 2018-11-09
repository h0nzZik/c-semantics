#!/bin/sh

set -e

source "$SETTINGS"

function install_k() {
	if [[ ! -d "$K_PATH" ]]; then
		echo "Cloning K"
		git clone "$K_REPO" "$K_PATH"
	fi
	cd "$K_PATH"
	git pull
	git checkout "$K_BRANCH"
	echo "Building K"
	mvn package -Dmaven.test.skip=true
	$K_BIN/k-configure-opam-dev < /dev/null
}

install_k


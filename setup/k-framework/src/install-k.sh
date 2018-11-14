#!/bin/bash

set -e

if [[ "$1" == "" ]]; then
	echo "Usage: $0 /where/to/put/k"
	exit
fi

K_DIR="$1"

# The official repository
K_REPO="https://github.com/kframework/k.git"
K_BRANCH="master"

echo "Cloning K"
git clone "$K_REPO" "$K_DIR"

echo "Building K"
cd "$K_DIR"
git checkout "$K_BRANCH"
mvn package -Dmaven.test.skip=true

K_BIN="$K_DIR/k-distribution/bin"

echo "Building K OCaml backend"
$K_BIN/k-configure-opam-dev < /dev/null

echo 'eval `opam config env`' >> ~/k.env
echo export PATH="$K_BIN:\$PATH" >> ~/k.env
echo 'source ~/k.env' >> ~/.bashrc



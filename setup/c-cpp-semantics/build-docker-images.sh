#!/bin/bash

if [[ -z "$DOCKER_PREFIX" ]]; then
	DOCKER_PREFIX="local"
fi

function build_fedora() {
	echo "Building image based on Fedora"
	docker build \
		-t $DOCKER_PREFIX/c-cpp-semantics-fedora \
		--build-arg DISTRO="fedora" \
		.
}

function build_debian() {
	echo "Building image based on Debian"
	docker build \
		-t $DOCKER_PREFIX/c-cpp-semantics-debian \
		--build-arg DISTRO="debian" \
		.
}

function build_alpine() {
	echo "Building image based on Alpine"
	docker build \
		-t $DOCKER_PREFIX/c-cpp-semantics-alpine \
		--build-arg DISTRO="alpine" \
		.
}

case "$1" in
	fedora)
		build_fedora ;;
	debian)
		build_debian ;;
	alpine)
		build_alpine ;;
	*)
		echo "Building all"
		build_fedora
		build_debian
		build_alpine
		;;
esac

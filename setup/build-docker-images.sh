#!/bin/bash

if [[ -z "$DOCKER_PREFIX" ]]; then
	DOCKER_PREFIX="local"
fi

function build_fedora() {
	echo "Building image based on Fedora"
	docker build \
		-t $DOCKER_PREFIX/kframework-fedora \
		-f ./docker/k/Dockerfile \
		--build-arg BASE="fedora:latest" \
		--build-arg DISTRO="fedora" \
		.
}

function build_debian() {
	echo "Building image based on Debian"
	docker build \
		-t $DOCKER_PREFIX/kframework-debian \
		-f ./docker/k/Dockerfile \
		--build-arg BASE="debian:stable" \
		--build-arg DISTRO="debian" \
		.
}

function build_alpine() {
	echo "Building image based on Alpine"
	docker build \
		-t $DOCKER_PREFIX/kframework-debian \
		-f ./docker/k/Dockerfile \
		--build-arg BASE="alpine:edge" \
		--build-arg DISTRO="alpine" \
		.
}

build_fedora
build_debian
build_alpine

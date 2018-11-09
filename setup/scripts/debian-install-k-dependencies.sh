#!/bin/sh

apt update -y

# Basic packages
apt install -y \
	sudo \
	git \
	vim \
	gcc \
	make \
	cmake \
	build-essential \
	pkg-config

# K dependencies
apt install -y \
	libxml2-dev \
	libmpfr-dev \
	libgmp-dev \
	openjdk-8-jdk \
	z3 \
	libz3-dev \
	flex \
	maven \
	python3 \
	libffi-dev \

# K ocaml backend dependencies
apt install -y \
	ocaml \
	opam  \
	perl


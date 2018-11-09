#!/bin/sh

# Basic packages
dnf install -y \
	sudo \
	git \
	vim \
	gcc \
	make \
	cmake

# K dependencies
dnf install -y \
	libxml2-devel \
	mpfr-devel \
	gmp-devel \
	java-1.8.0-openjdk \
	z3 \
	z3-devel \
	flex \
	maven \
	python3 \
	libffi-devel

# K ocaml backend dependencies
dnf install -y \
	ocaml \
	opam

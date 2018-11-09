#!/bin/sh

# Basic packages
apk add \
	sudo \
	git \
	vim \
	gcc \
	make \
	cmake \
	alpine-sdk

# K dependencies
apk add \
	libxml2-dev \
	mpfr-dev \
	gmp-dev \
	openjdk8 \
	z3 \
	z3-dev \
	flex \
	maven \
	python3 \
	libffi-dev \

# K ocaml backend dependencies
apk add \
	ocaml \
	opam  \
	perl

opam init --disable-sandboxing

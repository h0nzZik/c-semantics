#!/bin/bash

set -x

apt install -y \
	cmake \
	perl \
	diffutils \
	bison \
	zlib1g-dev \
	libuuid-tiny-perl \
	libxml-libxml-perl \
	libgetopt-declare-perl \
	libstring-escape-perl \
	libstring-shellquote-perl \
	libapp-fatpacker-perl \
	< /dev/null


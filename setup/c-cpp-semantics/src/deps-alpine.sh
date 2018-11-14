#!/bin/bash

set -x

apk add \
	ncurses-libs \
	ncurses-dev \
	bison \
	cmake \
	perl-utils \
	perl-xml-libxml \
	perl-string-shellquote \
	perl-log-log4perl \
	< /dev/null



# Those packages are not missing
cpan -i \
	Getopt::Declare \
	String::Escape \
	App::FatPacker \
	UUID::Tiny \
	< /dev/null


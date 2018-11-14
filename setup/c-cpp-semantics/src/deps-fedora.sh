#!/bin/bash

set -x

dnf install -y \
	wget \
	xz \
	gcc-c++ \
	ncurses-devel \
	bison \
	cmake \
	cpan \
	perl-libxml-perl \
	perl-String-Escape \
	perl-String-ShellQuote \
	perl-App-FatPacker \
	perl-UUID-Tiny \
	perl-XML-LibXML \
	perl-Log-Log4perl \
	< /dev/null

# Getopt::Declare is not present in Fedora
cpan -i Getopt::Declare < /dev/null



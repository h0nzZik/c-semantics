SHELL = /bin/sh

srcdir = @srcdir@
export OPAMROOT = $(CURDIR)/.opam

OCAMLFIND = $(OPAMROOT)/default/bin/ocamlfind

.PHONY: default
default: all


.PHONY: mytest
mytest: $(OPAMROOT)

$(OPAMROOT):
	opam init --no-setup

$(OCAMLFIND): $(OPAMROOT)
	opam install -y ocamlfind camomile

.PHONY: all
all: $(OCAMLFIND)
	opam config exec -- sh -c 'cd src; $(MAKE)'

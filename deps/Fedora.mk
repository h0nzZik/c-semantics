# Public:
# * system.all
# * system.java
# * system.git

.PHONY: system.all
system.all: system.ffi system.flex system.git system.java system.mpfr system.gmp system.ocaml system.perl system.z3

.PHONY: system.ffi
system.ffi: /usr/include/ffi.h

.PHONY: system.flex
system.flex: /usr/bin/flex

.PHONY: system.git
system.git: /usr/bin/git

.PHONY: system.gmp
system.gmp: /usr/include/gmp.h

.PHONY: system.java
system.java: /usr/bin/java /usr/bin/mvn

.PHONY: system.mpfr
system.mpfr: /usr/include/mpfr.h

.PHONY: system.ocaml
system.ocaml: /usr/bin/opam /usr/bin/ocaml

.PHONY: system.perl
system.perl: /usr/bin/perl

.PHONY: system.z3
system.z3: /usr/include/z3/z3.h /usr/bin/z3

/usr/bin/opam:
	sudo dnf install -y opam

/usr/bin/ocaml:
	sudo dnf install -y ocaml

/usr/bin/java:
	sudo dnf install -y java-1.8.0-openjdk

/usr/bin/mvn:
	sudo dnf install -y mvn

/usr/bin/flex:
	sudo dnf install -y flex

/usr/include/ffi.h:
	sudo dnf install -y libffi-devel

/usr/include/mpfr.h:
	sudo dnf install -y mpfr-devel

/usr/include/gmp.h:
	sudo dnf install -y gmp-devel

/usr/bin/z3:
	sudo dnf install -y z3

/usr/include/z3/z3.h:
	sudo dnf install -y z3-devel

/usr/bin/perl:
	sudo dnf install -y perl

/usr/bin/git:
	sudo dnf install -y git

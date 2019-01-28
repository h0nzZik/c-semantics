AC_INIT([com.runtimeverification.rv-match.cparser], [1.0])


AC_PROG_CC

AC_CHECK_PROG(OCAMLLEX,[ocamllex],[ocamllex],[no])
test "$OCAMLLEX" == "no" && AC_MSG_ERROR([Required program 'ocamllex' not found.])

AC_CHECK_PROG(OCAMLYACC,[ocamlyacc],[ocamlyacc],[no])
test "$OCAMLYACC" == "no" && AC_MSG_ERROR([Required program 'ocamlyacc' not found.])

AC_CHECK_PROG(OOPAM,[opam],[opam],[no])
test "$OPAM" == "no" && AC_MSG_ERROR([Required program 'opam' not found.])

#AC_CHECK_PROG(OCAMLFIND,[ocamlfind],[ocamlfind],[no])
#test "$OCAMLFIND" == "no" && AC_MSG_ERROR([Required program 'ocamlfind' not found.])

AC_CONFIG_FILES([Makefile])
AC_OUTPUT


# Ok, so we need to run `opam init --no-setup` in toplevel, because (1) K needs opam, (2) cparser needs opam. We probably do not mind installing new packages and switches...
# And: `opam install -y ocamlfind`
# And we need to run this under `system` switch.
# Here: just `opam install -y camomile`

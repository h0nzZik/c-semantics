AC_INIT([com.runtimeverification.rv-match.cparser], [1.0])


AC_PROG_CC

AC_CHECK_PROG(OCAMLLEX,[ocamllex],[ocamllex],[no])
test "$OCAMLLEX" == "no" && AC_MSG_ERROR([Required program 'ocamllex' not found.])

AC_CHECK_PROG(OCAMLYACC,[ocamlyacc],[ocamlyacc],[no])
test "$OCAMLYACC" == "no" && AC_MSG_ERROR([Required program 'ocamlyacc' not found.])

AC_CHECK_PROG(OOPAM,[opam],[opam],[no])
test "$OPAM" == "no" && AC_MSG_ERROR([Required program 'opam' not found.])

AC_CONFIG_FILES([Makefile] [src/Makefile])
AC_OUTPUT


# TODO vpath, srcdir
#
OCAML_LEX := ocamllex
OCAML_YACC := ocamlyacc
OCAMLOPT_FLAGS := -w a -warn-error a
OCAML_COMPILE := ocamlfind ocamlopt -package camomile $(OCAMLOPT_FLAGS) -I $(B) -c
OCAML_LINK := ocamlfind ocamlopt -package camomile -linkpkg $(OCAMLOPT_FLAGS) -I $(B)


.PHONY: default
default: cparser

clexer.ml: $(srcdir)/clexer.mll
	@echo Target $@
	@$(OCAML_LEX) $< -o $@

cparser.ml cparser.mli: $(srcdir)/cparser.mly cabs.cmx cabshelper.cmx
	@echo Target $@
	@$(OCAML_YACC) $<

lexerhack.cmx  lexerhack.cmi  : errormsg.cmx
whitetrack.cmx whitetrack.cmi : cabs.cmx cabshelper.cmx
escape.cmx     escape.cmi     : whitetrack.cmx
cprint.cmx     cprint.cmi     : escape.cmx cabs.cmx
longarray.cmx  longarray.cmi  : errormsg.cmx
growArray.cmx  growArray.cmi  : errormsg.cmx longarray.cmx
cabshelper.cmx cabshelper.cmi : errormsg.cmx growArray.cmx cabs.cmx
cparser.cmx                        : cabs.cmx cabshelper.cmx lexerhack.cmx cprint.cmx cparser.cmi
cabsDriver.cmx cabsDriver.cmi : cparser.cmx frontc.cmx clexer.cmx xmlPrinter.cmx
frontc.cmx     frontc.cmi     : errormsg.cmx whitetrack.cmx cprint.cmx clexer.cmx
clexer.cmx     clexer.cmi     : lexerhack.cmx cparser.cmx cprint.cmx cabshelper.cmx
xmlPrinter.cmx xmlPrinter.cmi : cabs.cmx escape.cmx

clexer.cmx cparser.cmx: %.cmx: %.ml
	@echo Target $@
	@$(OCAML_COMPILE) $< -o $@

%.cmx: $(srcdir)/%.ml
	@echo Target $@
	@echo from $<
	@$(OCAML_COMPILE) $< -o $@
	
cparser.cmi: cparser.mli cabs.cmx clexer.ml
	@echo Target $@
	@$(OCAML_COMPILE) $< -o $@
	
cabsDriver.cmx cabsDriver.cmi: xmlPrinter.cmx


# these are partially ordered by inclusion.  don't know how to avoid manually ordering these
MODULES := base64.cmx errormsg.cmx longarray.cmx growArray.cmx escape.cmx cabshelper.cmx whitetrack.cmx cprint.cmx lexerhack.cmx cabs.cmx clexer.cmx cparser.cmx frontc.cmx xmlPrinter.cmx cabsDriver.cmx

cparser: $(addprefix ,$(MODULES))
	@echo Target $@
	@$(OCAML_LINK) -o $@ str.cmxa nums.cmxa $^
	@-strip $@



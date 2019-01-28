# imports:
# - BUILD_ROOT
# exports:
# - CPARSER
# internal:
# - CPARSER_*

CPARSER_SRC := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
CPARSER_BUILD := $(BUILD_ROOT)/cparser

S := $(CPARSER_SRC)
B := $(CPARSER_BUILD)

CPARSER_OCAML_LEX := ocamllex
CPARSER_OCAML_YACC := ocamlyacc
CPARSER_OCAMLOPT_FLAGS := -w a -warn-error a
CPARSER_OCAML_COMPILE := ocamlfind ocamlopt -package camomile $(CPARSER_OCAMLOPT_FLAGS) -I $(B) -c
CPARSER_OCAML_LINK := ocamlfind ocamlopt -package camomile -linkpkg $(CPARSER_OCAMLOPT_FLAGS) -I $(B)

$(B)/clexer.ml: $(S)/clexer.mll
	@$(BUILDING)
	@$(CPARSER_OCAML_LEX) $< -o $@

# Need a copy inside the build directory
# because `ocamlyacc` does not support the `-o` switch.
$(B)/cparser.mly: $(S)/cparser.mly
	@$(BUILDING)
	@cp $< $@

$(B)/cparser.ml $(B)/cparser.mli: $(B)/cparser.mly $(B)/cabs.cmx $(B)/cabshelper.cmx
	@$(BUILDING)
	@$(CPARSER_OCAML_YACC) $<

$(B)/lexerhack.cmx  $(B)/lexerhack.cmi  : $(B)/errormsg.cmx
$(B)/whitetrack.cmx $(B)/whitetrack.cmi : $(B)/cabs.cmx $(B)/cabshelper.cmx
$(B)/escape.cmx     $(B)/escape.cmi     : $(B)/whitetrack.cmx
$(B)/cprint.cmx     $(B)/cprint.cmi     : $(B)/escape.cmx $(B)/cabs.cmx
$(B)/longarray.cmx  $(B)/longarray.cmi  : $(B)/errormsg.cmx
$(B)/growArray.cmx  $(B)/growArray.cmi  : $(B)/errormsg.cmx $(B)/longarray.cmx
$(B)/cabshelper.cmx $(B)/cabshelper.cmi : $(B)/errormsg.cmx $(B)/growArray.cmx $(B)/cabs.cmx
$(B)/cparser.cmx                        : $(B)/cabs.cmx $(B)/cabshelper.cmx $(B)/lexerhack.cmx $(B)/cprint.cmx $(B)/cparser.cmi
$(B)/cabsDriver.cmx $(B)/cabsDriver.cmi : $(B)/cparser.cmx $(B)/frontc.cmx $(B)/clexer.cmx $(B)/xmlPrinter.cmx
$(B)/frontc.cmx     $(B)/frontc.cmi     : $(B)/errormsg.cmx $(B)/whitetrack.cmx $(B)/cprint.cmx $(B)/clexer.cmx
$(B)/clexer.cmx     $(B)/clexer.cmi     : $(B)/lexerhack.cmx $(B)/cparser.cmx $(B)/cprint.cmx $(B)/cabshelper.cmx
$(B)/xmlPrinter.cmx $(B)/xmlPrinter.cmi : $(B)/cabs.cmx $(B)/escape.cmx

$(B)/clexer.cmx $(B)/cparser.cmx: $(B)/%.cmx: $(B)/%.ml
	@$(GENERATING)
	@$(CPARSER_OCAML_COMPILE) $< -o $@

$(B)/%.cmx: $(S)/%.ml
	@$(GENERATING)
	@$(CPARSER_OCAML_COMPILE) $< -o $@
	
$(B)/cparser.cmi: $(B)/cparser.mli $(B)/cabs.cmx $(B)/clexer.ml
	@$(GENERATING)
	@$(CPARSER_OCAML_COMPILE) $< -o $@
	
$(B)/cabsDriver.cmx $(B)/cabsDriver.cmi: $(B)/xmlPrinter.cmx


# these are partially ordered by inclusion.  don't know how to avoid manually ordering these
CPARSER_MODULES := base64.cmx errormsg.cmx longarray.cmx growArray.cmx escape.cmx cabshelper.cmx whitetrack.cmx cprint.cmx lexerhack.cmx cabs.cmx clexer.cmx cparser.cmx frontc.cmx xmlPrinter.cmx cabsDriver.cmx

$(B)/cparser: $(addprefix $(B)/,$(CPARSER_MODULES))
	@$(GENERATING)
	@$(CPARSER_OCAML_LINK) -o $@ str.cmxa nums.cmxa $^
	@-strip $@

# Exports
CPARSER := $(CPARSER_BUILD)/cparser

# Cleanup
undefine B
undefine S

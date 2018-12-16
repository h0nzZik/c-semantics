SRCD := $(CURDIR)

include ../inc.mk

ifneq ($(MAKECMDGOALS),clean)
  ifeq ($(strip $(BUILD_DIR)),)
    $(error Need BUILD_DIR)
  endif
endif


EXEEXT=
# CIL_BASE = ../cil
# CIL_PLATFORM ?= $(firstword $(shell ls $(CIL_BASE)/obj))
# no warnings
OCAMLOPT_FLAGS := -w a -warn-error a 
# all warnings
#OCAMLOPT_FLAGS = -w A -warn-error A

# CIL = $(CIL_BASE)/obj/$(CIL_PLATFORM)

OCAML_COMPILE := ocamlfind ocamlopt -package camomile $(OCAMLOPT_FLAGS) -I $(B) -c

OCAML_LEX := ocamllex
OCAML_YACC := ocamlyacc
OCAML_LINK := ocamlfind ocamlopt -package camomile -linkpkg $(OCAMLOPT_FLAGS) -I $(B)

# these are partially ordered by inclusion.  don't know how to avoid manually ordering these
MODULES := $(addprefix $(B)/,base64.cmx errormsg.cmx longarray.cmx growArray.cmx escape.cmx cabshelper.cmx whitetrack.cmx cprint.cmx lexerhack.cmx cabs.cmx clexer.cmx cparser.cmx frontc.cmx xmlPrinter.cmx cabsDriver.cmx)

#IOXML = ioxml/ioXML.cmx ioxml/pa_ioXML.cmo
#ioxml

.PHONY:
default: distribute

CPARSER := cparser$(EXEEXT)


# $(IOXML): ioxml/ioXML.ml ioxml/ioXML.mli ioxml/pa_ioXML.ml
# make -C ioxml all

# xmlPrinter.ml: cabs.ml $(IOXML)
# camlp5o ioxml/pa_ioXML.cmo pr_o.cmo -sep "\n\n" cabs.ml > xmlPrinter.tmp
# sed -i '2 i open Cabs' xmlPrinter.tmp
# mv xmlPrinter.tmp xmlPrinter.ml

$(B)/clexer.ml: clexer.mll
	@$(BUILDING)
	@$(OCAML_LEX) $< -o $@

$(B)/cparser.ml $(B)/cparser.mli: cparser.mly $(B)/cabs.cmx $(B)/cabshelper.cmx
	@$(BUILDING)
	@$(OCAML_YACC) $<
	@mv cparser.ml $(B)
	@mv cparser.mli $(B)

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
	@$(OCAML_COMPILE) $< -o $@

$(B)/%.cmx: %.ml 
	@$(GENERATING)
	@$(OCAML_COMPILE) $*.ml -o $@
	
$(B)/cparser.cmi: $(B)/cparser.mli $(B)/cabs.cmx $(B)/clexer.ml
	@$(GENERATING)
	@$(OCAML_COMPILE) $(B)/cparser.mli -o $@
	
$(B)/cabsDriver.cmx $(B)/cabsDriver.cmi: $(B)/xmlPrinter.cmx


$(B)/$(CPARSER): $(MODULES)
	@$(GENERATING)
	@$(OCAML_LINK) -o $@ str.cmxa nums.cmxa $^
	@-strip $@
#ioXML.cmx 

.PHONY: build
build: $(B)/$(CPARSER)

.PHONY: distribute
distribute: $(DIST_ROOT)/$(CPARSER)

$(DIST_ROOT)/$(CPARSER): $(B)/$(CPARSER)
	cp $< $@

.PHONY: clean
clean:
	rm -f *.cmi *.cmx *.o *.mli *.cil cparser.ml clexer.ml *.preprocessed cparser.exe cparser *.stackdump
#make -C ioxml clean

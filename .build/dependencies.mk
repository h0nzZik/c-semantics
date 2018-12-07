include $(dir $(lastword $(MAKEFILE_LIST)))/inc.mk


.PHONY: dependencies
dependencies: have-kompile have-ocaml have-gcc have-perl

.PHONY: have-kompile
# We do not necessarily need to have $(K_BIN)/kompile.
# Any $(KOMPILE) is good.
have-kompile: $(KOMPILE)
$(K_BIN)/kompile:
	@echo "== submodule: $@"
	git submodule update --init -- $(K_SUBMODULE_DIR)
	cd $(K_SUBMODULE_DIR) && mvn package -q -DskipTests -U

.PHONY: have-ocaml
have-ocaml:
	@if ! ocaml -version > /dev/null 2>&1; then echo "ERROR: You don't seem to have ocaml installed.  You need to install this before continuing.  Please see INSTALL.md for more information."; false; fi

.PHONY: have-gcc
have-gcc:
	@if ! gcc -v > /dev/null 2>&1; then if ! clang -v > /dev/null 2>&1; then echo "ERROR: You don't seem to have gcc or clang installed.  You need to install this before continuing.  Please see INSTALL.md for more information."; false; fi fi

.PHONY: have-perl
have-perl:
	@perl $(SCRIPTS_DIR)/checkForModules.pl




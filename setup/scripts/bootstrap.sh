#!/bin/bash

set -e

# Variable SCRIPTS may be set from Docker

if [[ -z "$SCRIPTS" ]]; then
	SCRIPTS="$APP_ROOT/scripts"
fi

source /etc/os-release
case $ID in
	fedora )
		source "$SCRIPTS/platforms/fedora.sh" ;;
	ubuntu )
		source "$SCRIPTS/platforms/ubuntu.sh" ;;
esac

source "$SCRIPTS/settings.sh"

function update_system() {
	echo "== Updating system"
	platform_system_update

}

function install_basic_packages() {
	echo "== Installing basic packages"
	platform_install_basic_packages
}

function prepare_basics() {
	update_system
	install_basic_packages
	mkdir -p $SW_DIR
}

function install_k_dependencies() {
	echo "== Installing K dependencies"
	platform_install_k_dependencies
}


function install_ocaml() {
	echo "Installing OCaml"
	platform_install_ocaml
	echo "Configuring patched OCaml"
	$K_BIN/k-configure-opam-dev < /dev/null
}

CGMEMTIME="$SW_DIR/cgmemtime/cgmemtime"
# We use cgmemtime to measure the memory consumption
# of the build process
function install_cgmemtime() {
	if [[ -d "$SW_DIR/cgmemtime" ]]; then
		echo "cgmemtime seem to be already installed"
		return
	fi
	pushd "$SW_DIR"
	git clone https://github.com/gsauthof/cgmemtime.git
	cd cgmemtime
	make
	popd
	sudo $CGMEMTIME --setup -g $(id -gn) --perm 775
}

function install_c_semantics_dependencies() {
	echo "Installing C-semantics dependencies"
	platform_install_c_semantics_dependencies
	"$SCRIPTS/install_clang.sh"
	install_cgmemtime
}

C_SEMANTICS_DIR="$APP_ROOT/c-semantics"

function grab_c_semantics() {

	if [[ ! -d "$C_SEMANTICS_DIR" ]]; then
		echo "Cloning c-semantics"
		git clone "$C_SEMANTICS_REPO" "$C_SEMANTICS_DIR"
	fi
	pushd "$C_SEMANTICS_DIR"
	git checkout "$C_SEMANTICS_BRANCH"
	popd
}

function build_c_semantics() {
	source "$SCRIPTS/env.sh"
	cd "$C_SEMANTICS_DIR"
	pushd clang-tools
		cmake -DCMAKE_CXX_FLAGS="-fno-rtti" -DLLVM_PATH="$CLANG_PATH" .
	popd
	$CGMEMTIME make
}

function main() {
	prepare_basics
	"$SCRIPTS/install_k.sh"
	install_ocaml
	install_c_semantics_dependencies
	grab_c_semantics
	build_c_semantics
}

LOGFILE="$APP_ROOT/log.txt"

function log() {
  "$@" 2>&1 | tee -a "$LOGFILE"
}

function provision() {
	log echo
	log echo
	log echo
	log echo "Running provisioning script"
	log date
	log echo
	log main
}

provision

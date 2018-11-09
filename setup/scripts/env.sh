#!/bin/bash
# Prepares environment for K and ocaml-backend

source "$SETTINGS"

eval `opam config env`

export PATH="$K_BIN:$PATH"



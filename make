#!/bin/bash

if [[ $BUILD_DIR == "" ]]; then
  BUILD_DIR=$(pwd)/build
fi

echo "Building in $BUILD_DIR"
make BUILD_DIR="$BUILD_DIR" "$@" | ./src/logger "$BUILD_DIR/build.log"

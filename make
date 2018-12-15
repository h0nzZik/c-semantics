#!/bin/bash

if [[ $BUILD_ROOT == "" ]]; then
  BUILD_ROOT=$(pwd)/build
fi

echo "Building in $BUILD_ROOT"
make BUILD_ROOT="$BUILD_ROOT" "$@" 2>&1 | ./src/logger "$BUILD_ROOT/build.log"

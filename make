#!/bin/bash

if [[ $BUILD_ROOT == "" ]]; then
  BUILD_ROOT=$(pwd)/build
fi


echo "Building in $BUILD_ROOT"
D=$(date '+%Y-%m-%d_%H-%M-%S')
mkdir -p "$BUILD_ROOT/logs"
rm -f "$BUILD_ROOT/log"
ln -s  "$BUILD_ROOT/logs/$D.log" "$BUILD_ROOT/log"

make BUILD_ROOT="$BUILD_ROOT" "$@" 2>&1 | ./src/logger "$BUILD_ROOT/logs/$D.log"

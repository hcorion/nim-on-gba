#!/bin/bash

for dir in ./*/; do
  pushd "$dir"
  [[ -f nakefile.nim ]] && nim c -r nakefile.nim build
  popd
done
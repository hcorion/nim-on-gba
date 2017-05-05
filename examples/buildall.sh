#!/bin/sh

for dir in ./*; do
  cd "$dir"
  [[ -f nakefile.nim ]] && nim c -r nakefile.nim build
done
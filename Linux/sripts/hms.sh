#!/bin/bash

set -e
parent_path=$(
  cd "$(dirname "${BASH_SOURCE[0]}")"
  pwd -P
)
cd "$parent_path"

./make_hm.sh
export NIXPKGS_ALLOW_UNFREE=1
home-manager switch --impure --show-trace --flake . -b backup | tee hms.log

# Track backed up files 
cat hms.log | grep -o "Existing file '[^']*'" | cut -d"'" -f2 >> ../../backed_up_files.txt
rm hms.log
sort -uo ../../backed_up_files.txt ../../backed_up_files.txt


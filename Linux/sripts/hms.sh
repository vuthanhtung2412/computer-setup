#!/bin/bash

set -e
parent_path=$(
  cd "$(dirname "${BASH_SOURCE[0]}")"
  pwd -P
)
cd "$parent_path"

./make_hm.sh
export NIXPKGS_ALLOW_UNFREE=1
home-manager switch --impure --show-trace --flake . -b backup

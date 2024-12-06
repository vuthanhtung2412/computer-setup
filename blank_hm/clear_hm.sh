#!/bin/bash

set -e
parent_path=$(
  cd "$(dirname "${BASH_SOURCE[0]}")"
  pwd -P
)
cd "$parent_path"

sed -e "s|<home>|$HOME|g" -e "s|<user>|$USER|g" "home_template.nix" >home.nix
home-manager -f ./home.nix switch
# TODO: restore backup config

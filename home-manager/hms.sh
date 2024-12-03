#!/bin/bash
yes | rm -r ~/.cache/antidote
yes | rm -r ~/.vscode/extensions
./create_flake.sh
export NIXPKGS_ALLOW_UNFREE=1
home-manager switch --impure --show-trace --flake . -b backup

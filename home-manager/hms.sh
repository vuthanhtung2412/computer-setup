#!/bin/bash
yes | rm -r ~/.cache/antidote
yes | rm -r ~/.vscode/extensions
./create_flake.sh
home-manager switch --impure --show-trace --flake . -b backup

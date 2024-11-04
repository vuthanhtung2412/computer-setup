yes | rm -rf /Users/tung/Library/Caches/antidote/ 
yes | rm -r ~/.vscode/extensions
./create_flake.sh
home-manager switch --impure --show-trace --flake .
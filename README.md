# computer-setup
Set up script for my personal computer
+ Make file : each group of software will correspond to a task
+ Maintain a list of dotfiles with **chezmoi**

# Some thoughts about Nix

## Personal usage :
+ Each program has their config file as their first support (neovim, zsh, oh my zsh, vscode, starship)
+ Nix doesn't come with cask
+ When a program is released it will be on apt, dnf, pacman, brew first instead of nix 
+ Personal usage doesn't require strong reproducibility guarantee

## Development
+ Every language has its own package manager, it doesn't use nix as first class support (we publish package to pip, go mod, cargo, npm but not nix)
+ Projects like maven2nix, node2nix, gradle2nix introduces a lot of overhead. Go mod and cargo is declarative already :)))
+ When it comes to deployment, docker is enough.

## User experience
+ Nix is way to hard to write and understand for configuration

## Some niche that might be good for nix 
+ Include dev tools like (fzf, jq, kafka-cat) in the project
  
## Reference 
+ [Nix starter template](https://github.com/Misterio77/nix-starter-configs)
+ [Installing Nix](https://github.com/DeterminateSystems/nix-installer)
+ [Installing home-manager](https://nix-community.github.io/home-manager/#sec-install-standalone)
+ [Home manager option](https://nix-community.github.io/home-manager/options.xhtml)
+ Some great ressource for devenv with Nix
  + [dev env nix template](https://github.com/the-nix-way/dev-templates)
  + [article about nix devenv](https://determinate.systems/posts/nix-direnv/)
  + https://github.com/nix-community/home-manager
  + https://discourse.nixos.org/t/using-home-manager-to-control-default-user-shell/8489/4
  + https://home-manager-options.extranix.com/?query=zshrc&release=release-24.05

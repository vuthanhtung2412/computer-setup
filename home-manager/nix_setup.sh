# Install nix
sudo apt install curl 
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# Restart shell
source ~/.bashrc 
exec bash 

# Install home manager
nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

# create generate flake.nix file 
. create_flake.sh

# Install nerd font for oh my posh
# kickstart neovim
# docker 
# warp terminal
# wezterm
# install microk8s (for Ubuntu)/ k3s (for others) and k9s
# change .desktop file at /usr/share/applications or ~/.local/share/applications to use nixgl wrapper 
# Use xorg instead of wayland by default : https://askubuntu.com/questions/1434298/set-ubuntu-on-xorg-by-default-globally-but-without-preventing-the-choice-of-wa
#!/bin/bash

# Update and upgrade the system
sudo apt update && sudo apt upgrade -y# update and upgrade apt

# Install nix
sudo apt install curl
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# Restart shell
source ~/.bashrc
exec bash

# Install home manager
nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

# Install nerd font
echo "[-] Download fonts [-]"
echo https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip
wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip"
unzip JetBrainsMono.zip -d ~/.fonts
fc-cache -fv
echo "done!"

# kickstart neovim
git clone https://github.com/nvim-lua/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim

# Docker
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
  sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
sudo apt-get update
# Install docker package
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# Verify installation
sudo docker run hello-world
sudo usermod -aG docker $USER

# install microk8s (for Ubuntu)/ k3s (for others)
sudo snap install microk8s --classic --channel=1.31
sudo usermod -a -G microk8s $USER
mkdir -p ~/.kube
chmod 0700 ~/.kube
microk8s status --wait-ready
microk8s kubectl get nodes

# Set zsh (installed by nix) as default shell
sudo sh -c 'echo /home/tung/.nix-profile/bin/zsh >> /etc/shells'
chsh -s /home/tung/.nix-profile/bin/zsh

# Install tailscale
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list
sudo apt-get update
sudo apt-get install tailscale
sudo tailscale up

# Add user to input group for fumusa touchpad setup
sudo usermod -aG input $(whoami)

# Install Nvidia driver 550 since nix 24.05 linuxPackages.nvidia_x11 supports this version (however still mismatch 550.78 vs 550.107)
# Mismatch nvidia driver cuda runtime and cuda toolkit version (12.4 vs 12.6)
# sudo ubuntu-drivers install (recommand v560). However, it is a beta version at the time and driver v550 is still recommended at https://www.nvidia.com/en-us/drivers/
sudo ubuntu-drivers install nvidia:550

# Use xorg instead of wayland by default : https://askubuntu.com/questions/1434298/set-ubuntu-on-xorg-by-default-globally-but-without-preventing-the-choice-of-wa

# set up ibus bamboo for vietnamese typing
sudo add-apt-repository ppa:bamboo-engine/ibus-bamboo
sudo apt-get update
sudo apt-get install ibus ibus-bamboo --install-recommends
ibus restart
# Đặt ibus-bamboo làm bộ gõ mặc định
env DCONF_PROFILE=ibus dconf write /desktop/ibus/general/preload-engines "['BambooUs', 'Bamboo']" && gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('ibus', 'Bamboo')]"

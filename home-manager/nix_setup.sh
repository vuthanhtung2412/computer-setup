# Update and upgrade the system
sudo apt update && sudo apt upgrade -y# update and upgrade apt

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

# Installation with home manager 
home-manager switch --impure --flake .

# Install nerd font
echo "[-] Download fonts [-]"
echo https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip
wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip"
unzip JetBrainsMono.zip -d ~/.fonts
fc-cache -fv
echo "done!"

# Set up nerdfont for terminal and vscode 
# "terminal.integrated.fontFamily": "'JetBrainsMono Nerd Font'"

# Install Brave
sudo apt install curl
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install brave-browser

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
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
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
 
# Install ulauncher manually since it nix-installed version doesn't support start on login
sudo add-apt-repository universe -y && sudo add-apt-repository ppa:agornostal/ulauncher -y && sudo apt update && sudo apt install ulauncher

# Set zsh (installed by nix) as default shell
sudo sh -c 'echo /home/tung/.nix-profile/bin/zsh >> /etc/shells'
chsh -s /home/tung/.nix-profile/bin/zsh

# Install tailscale
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list
sudo apt-get update
sudo apt-get install tailscale
sudo tailscale up

# Use xorg instead of wayland by default : https://askubuntu.com/questions/1434298/set-ubuntu-on-xorg-by-default-globally-but-without-preventing-the-choice-of-wa
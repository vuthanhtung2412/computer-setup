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

# Install nerd font
echo "[-] Download fonts [-]"
echo https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip
wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip"
unzip JetBrainsMono.zip -d ~/.fonts
fc-cache -fv
echo "done!"

# Set up nerdfont for terminal and vscode 
# "terminal.integrated.fontFamily": "'JetBrainsMono Nerd Font'"

# kickstart neovim
# docker 
# install microk8s (for Ubuntu)/ k3s (for others) and k9s
# Install ulauncher manually since it nix-installed version doesn't support start on login
# Use xorg instead of wayland by default : https://askubuntu.com/questions/1434298/set-ubuntu-on-xorg-by-default-globally-but-without-preventing-the-choice-of-wa
#!/bin/bash

# Accept untrusted
cd /etc/apt
sudo cp trusted.gpg trusted.gpg.d

# Update and upgrade the system
sudo apt update && sudo apt upgrade -y

# Install essential tools
sudo apt install -y jq ffmpeg direnv bat tmux tmate yt-dlp ripgrep thefuck tldr zoxide xclip git git-lfs copyq htop parallel vim

# Install zoxide
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# Install tpm (tmux package manager)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install nix, home manager 
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

# Install and change ZSH to default shell
sudo apt install zsh -y
sudo chsh -s $(which zsh)
## Install Oh My Zsh and Zsh plugins
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/jeffreytse/zsh-vi-mode $ZSH_CUSTOM/plugins/zsh-vi-mode
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
sudo apt install -y xdotool wmctrl
git clone https://github.com/marzocchi/zsh-notify $ZSH_CUSTOM/plugins/notify
## Add plugins to .zshrc
sed -i 's/plugins=(git)/plugins=(git zsh-vi-mode zsh-syntax-highlighting zsh-autosuggestions notify z)/' ~/.zshrc

# Install chezmoi
sudo sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/bin

# Install brew
sudo apt-get install build-essential
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
(echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> ~/.zshrc
(echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> ~/.bashrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Install fzf https://gist.github.com/aclarknexient/0ffcb98aa262c585c49d4b3f3ae24019#install-fzf 
# Conflict between zsh vi mode and fzf : https://github.com/junegunn/fzf/issues/1304#issuecomment-1885944912
brew install fzf
$(brew --prefix)/opt/fzf/install 

# Install npm and update
sudo apt install nodejs npm -y
node -v
# Update node version
sudo npm install -g n
sudo n lts
sudo n latest
n prune
# Install diff-so-fancy
sudo npm i -g diff-so-fancy

# Install yq
sudo add-apt-repository ppa:rmescandon/yq
sudo apt update
sudo apt install yq -y

# Install Wezterm
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo apt update
sudo apt install wezterm

# Install Oh my Posh https://calebschoepp.com/blog/2021/how-to-setup-oh-my-posh-on-ubuntu/ 
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh
## Download fonts 
oh-my-posh font install meslo
## Download the themes
mkdir ~/.poshthemes
wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O ~/.poshthemes/themes.zip
unzip ~/.poshthemes/themes.zip -d ~/.poshthemes
chmod u+rw ~/.poshthemes/*.json
rm ~/.poshthemes/themes.zip
### Choose slimfat theme 
echo 'eval "$(oh-my-posh init zsh --config ~/.poshthemes/slimfat.omp.json)"' >> ~/.zshrc
echo 'eval "$(oh-my-posh init bash --config ~/.poshthemes/slimfat.omp.json)"' >> ~/.bashrc

# Set up Neovim https://github.com/neovim/neovim/blob/master/INSTALL.md#pre-built-archives-2
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
echo PATH="$PATH:/opt/nvim-linux64/bin" >> ~/.profile
source ~/.profile
git clone https://github.com/nvim-lua/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim

# Install Visual Studio Code
# Add repository and key to apt
sudo apt-get install wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
rm -f packages.microsoft.gpg
# Install VSCode
sudo apt install apt-transport-https
sudo apt update
sudo apt install code # or code-insiders

# Install VSCode Extensions
code --install-extension GitHub.vscode-pull-request-github
code --install-extension eamodio.gitlens
code --install-extension mhutchie.git-graph
code --install-extension ms-vsliveshare.vsliveshare
code --install-extension ms-vscode-remote.remote-ssh
code --install-extension ms-vscode.cpptools-extension-pack
code --install-extension vscjava.vscode-java-pack
code --install-extension golang.go
code --install-extension ecmel.vscode-html-css
code --install-extension christian-kohler.npm-intellisense
code --install-extension ritwickdey.LiveServer
code --install-extension ms-toolsai.jupyter
code --install-extension ms-python.python
code --install-extension donjayamanne.python-environment-manager
code --install-extension njpwerner.autodocstring
code --install-extension ms-vscode.intellicode
code --install-extension rust-lang.rust-analyzer
code --install-extension bbenoist.Nix
code --install-extension formulahendry.code-runner
code --install-extension esbenp.prettier-vscode
code --install-extension dbaeumer.vscode-eslint
code --install-extension ms-azuretools.vscode-docker
code --install-extension ms-azuretools.vscode-helm
code --install-extension ms-kubernetes-tools.vscode-kubernetes-tools
code --install-extension Catppuccin.catppuccin-vscode
code --install-extension vscodevim.vim
code --install-extension alefragnani.Bookmarks
code --install-extension tomoki1207.pdf
code --install-extension streetsidesoftware.code-spell-checker
code --install-extension usernamehw.errorlens
code --install-extension pkief.material-icon-theme
code --install-extension shd101wyy.markdown-preview-enhanced

# Install Python and related tools
sudo apt install -y python3 python3-pip python3-venv
pip3 install jupyterlab notebook

# Install Java and Maven
sudo apt install -y openjdk-21-jdk maven openjdk-21-jre
java --version

# Install Golang
wget https://go.dev/dl/go1.22.6.linux-amd64.tar.gz -O go.tar.gz
sudo tar -xzvf go.tar.gz -C /usr/local
rm go.tar.gz
echo export PATH=$HOME/go/bin:/usr/local/go/bin:$PATH >> ~/.profile
source ~/.profile
go version 

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup update

# Install eza
cargo install eza

# Install yazi
cargo install --locked yazi-fm yazi-cli

# Install Docker
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
## Install docker package 
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
## Test Docker
sudo docker run hello-world
# Some fault of docker
# link1 : https://stackoverflow.com/questions/41133455/docker-repository-does-not-have-a-release-file-on-running-apt-get-update-on-ubun
# link2 : https://unix.stackexchange.com/questions/735260/dockset-option -sa terminal-overrides ",xterm*:Tc"
set -g mouse on

unbind C-b
set -g prefix C-Space
bind C-Space send-prefix

# Vim style pane selection
bind h select-pane -L
bind j select-pane -D 
bind k select-pane -U
bind l select-pane -R

# Start windows and panes at 1, not 0
set -g base-index 1
set -g pane-base-index 1
set-window-option -g pane-base-index 1
set-option -g renumber-windows on

# Use Alt-arrow keys without prefix key to switch panes
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D

# Shift arrow to switch windows
bind -n S-Left  previous-window
bind -n S-Right next-window

# Shift Alt vim keys to switch windows
bind -n M-H previous-window
bind -n M-L next-window

set -g @catppuccin_flavour 'mocha'

set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'christoomey/vim-tmux-navigator'
set -g @plugin 'dreamsofcode-io/catppuccin-tmux'
set -g @plugin 'tmux-plugins/tmux-yank'

run '~/.tmux/plugins/tpm/tpm'

# set vi-mode
set-window-option -g mode-keys vi
# keybindings
bind-key -T copy-mode-vi v send-keys -X begin-selection
bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

bind '"' split-window -v -c "#{pane_current_path}"
bind % split-window -h -c "#{pane_current_path}"er-does-not-have-a-release-file 

# Install Obsidian plugins https://snapcraft.io/docs/installing-snap-on-linux-mint
sudo mv /etc/apt/preferences.d/nosnap.pref ~/Documents/nosnap.backup
sudo apt update
sudo apt install snapd
sudo snap install obsidian --classic

# Install Warp terminal (this is better off installed by hand, ubuntu 22.04 have deprecation issue) 
# sudo apt-get install wget gpg
# wget -qO- https://releases.warp.dev/linux/keys/warp.asc | gpg --dearmor > warpdotdev.gpg
# sudo install -D -o root -g root -m 644 warpdotdev.gpg /etc/apt/keyrings/warpdotdev.gpg
# sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/warpdotdev.gpg] https://releases.warp.dev/linux/deb stable main" > /etc/apt/sources.list.d/warpdotdev.list'
# rm warpdotdev.gpg
# sudo apt update && sudo apt install warp-terminal

# Install ULancher
sudo add-apt-repository universe -y && sudo add-apt-repository ppa:agornostal/ulauncher -y && sudo apt update && sudo apt install ulauncher

### TODO BELOW ###

# Install Kubernetes tools (kubectl, k9s, helm)
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

curl -LO https://github.com/derailed/k9s/releases/download/v0.25.18/k9s_Linux_x86_64.tar.gz
tar -xvf k9s_Linux_x86_64.tar.gz
sudo mv k9s /usr/local/bin/k9s

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Window Management tools (i3)
sudo apt install -y i3

# Browsers
sudo apt install -y firefox
# Install other browsers like Brave or Chrome from their respective websites

echo "Installation script completed. Some tools and extensions might require further manual setup."

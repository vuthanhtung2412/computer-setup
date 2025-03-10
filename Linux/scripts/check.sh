#!/bin/bash

# Array of applications to check
apps=(
  "code"
  "albert"
  "blueman-applet"
  "brave-browser"
  "neofetch"
  "jq"
  "yq"
  "ffmpeg"
  "yt-dlp"
  "fd"
  "rg"
  "thefuck"
  "hurl"
  "tldr"
  "xclip"
  "git"
  "git-lfs"
  "gh"
  "glab"
  "btop"
  "parallel"
  "nvim"
  "delta"
  "chezmoi"
  "ifconfig"
  "xournalpp"
  "docker"
  "python"
  "nixfmt"
  "kubectl"
  "kubectx"
  "k9s"
  "helm"
  "warp-terminal"
  "obsidian"
  "blender"
  "obs"
  "aws"
  "az"
  "gcloud"
  "terraform"
  "zsh"
  "bash"
  "tmux"
  "tmate"
  "mise"
  "bat"
  "lazygit"
  "fzf"
  "oh-my-posh"
  "vim"
  "kitty"
  "yazi"
  "eza"
  "zoxide"
  "chromium"

  # Services
  "copyq"

)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo "Checking installed applications..."
missing_apps=()

for app in "${apps[@]}"; do
  if ! command -v "$app" &>/dev/null; then
    missing_apps+=("$app")
    echo -e "${RED}✗ $app not found${NC}"
  else
    echo -e "${GREEN}✓ $app installed${NC}"
  fi
done

if [ ${#missing_apps[@]} -eq 0 ]; then
  echo -e "\n${GREEN}All applications are installed!${NC}"
else
  echo -e "\n${RED}Missing applications:${NC}"
  printf '%s\n' "${missing_apps[@]}"
fi

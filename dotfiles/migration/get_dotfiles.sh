#!/bin/bash

RED='\033[0;31m'   # Red
GREEN='\033[0;32m' # Green
NC='\033[0m'       # No Color

# Get the current user's home directory
if [ -n "$SUDO_USER" ]; then
  USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
else
  echo -e "${RED}Some command might fail without root previlege"
  echo -e "${RED}Please run 'sudo ./get_dotfiles.sh'"
  echo "---"
  USER_HOME="$HOME"
fi

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Create the backup directory if it doesn't exist
mkdir -p "$SCRIPT_DIR"

# Function to normalize file/directory names while preserving file extensions
normalize_name() {
  local path="$1"
  local relative_path="${path#$USER_HOME/}" # Strip the $HOME prefix
  local filename="$(basename "$relative_path")"
  local dirname="$(dirname "$relative_path")"

  # Extract the base name and extension
  local base="${filename%.*}" # File name without extension
  local ext="${filename##*.}" # File extension
  if [ "$base" == "$ext" ]; then
    ext="" # Handle files with no extension
  else
    ext=".$ext"
  fi

  # Replace '.config' in the path with 'dotconfig'
  dirname="${dirname//.config/dotconfig}"

  # Replace '/' with '_' and '.' with 'dot' in the directory and base name
  local normalized_dir="${dirname//\//_}"
  local normalized_base="${base//./dot}"

  # Combine normalized parts
  if [ "$normalized_dir" == "." ]; then
    echo "${normalized_base}${ext}"
  else
    echo "${normalized_dir}_${normalized_base}${ext}"
  fi
}

# Function to backup a file or directory
backup_item() {
  local path="$1"

  if [ -f "$path" ]; then
    local filename="$(normalize_name "$path")"
    cp "$path" "$SCRIPT_DIR/$filename"
    echo -e "$GREEN✓ Backed up file: $path as $filename"
  elif [ -d "$path" ]; then
    local dirname="$(normalize_name "$path")"
    mkdir -p "$SCRIPT_DIR/$dirname"
    cp -r "$path/"* "$SCRIPT_DIR/$dirname/" 2>/dev/null
    echo -e "$GREEN✓ Backed up directory: $path as $dirname"
  else
    echo -e "$RED✗ Not found or unsupported: $path"
  fi
}

# List of items to back up
backup_item "$USER_HOME/.bashrc"
backup_item "$USER_HOME/.zshrc"
backup_item "$USER_HOME/.config/git/config"
backup_item "$USER_HOME/.config/bat/config"
backup_item "$USER_HOME/.config/lazygit/config.yml"
backup_item "$USER_HOME/.config/oh-my-posh/config.json"
backup_item "$USER_HOME/.config/yazi"
backup_item "$USER_HOME/.config/mise/config.toml"
backup_item "$USER_HOME/.config/tmux/tmux.conf"
backup_item "$USER_HOME/.vimrc"
backup_item "$USER_HOME/.vim/vimrc"
backup_item "$USER_HOME/.config/kitty/kitty.conf"
backup_item "$USER_HOME/.config/Code/User/settings.json"
backup_item "$USER_HOME/.zsh_plugins.txt"

# Fzf options is stored in environment variables
# ❯ env | grep -i fzf
# FZF_CTRL_T_COMMAND=fd --type f
# FZF_DEFAULT_OPTS=--color bg:#1e1e2e,bg+:#313244,fg:#cdd6f4,fg+:#cdd6f4,header:#cba6f7,hl:#cba6f7,hl+:#cba6f7,info:#cba6f7,marker:#cba6f7,pointer:#cba6f7,prompt:#cba6f7,spinner:#f5e0dc
# FZF_CTRL_T_OPTS=--preview 'bat --style=numbers --color=always --line-range :300 {}'
# FZF_TMUX=1

echo -e "\nBackup completed! Files are stored in $SCRIPT_DIR"
echo "Backup summary:"
ls -la "$SCRIPT_DIR" | tail -n +4 # Skip the first 3 lines (total and . / ..)

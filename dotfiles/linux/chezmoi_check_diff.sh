#!/bin/bash

set -e
parent_path=$(
  cd "$(dirname "${BASH_SOURCE[0]}")"
  pwd -P
)
cd "$parent_path"

RED='\033[0;31m'   # Red
GREEN='\033[0;32m' # Green
NC='\033[0m'       # No Color

check_diff() {
  if diff "$1" "$2" > /dev/null; then
    echo -e "$GREEN✓ chezmoi and hm '$1' are the same.$NC"
  else
    echo -e "$RED✗ chezmoi and hm '$1' are different.$NC"
  fi
}

check_diff "$HOME/.bashrc" ".bashrc"
check_diff "$HOME/.vimrc" ".vimrc"
check_diff "$HOME/.zshrc" ".zshrc"
check_diff "$HOME/.config/bat/config" "dot_config_bat_config"
check_diff "$HOME/.config/Code/User/settings.json" "./dot_config_Code_User_settings.json"
check_diff "$HOME/.config/git/config" "./dot_config_git_config"
check_diff "$HOME/.config/kitty/kitty.conf" "./dot_config_kitty_kitty.conf"
check_diff "$HOME/.config/lazygit/config.yml" "./dot_config_lazygit_config.yml"
check_diff "$HOME/.config/mise/config.toml" "./dot_config_mise_config.toml"
check_diff "$HOME/.config/oh-my-posh/config.json" "./dot_config_oh-my-posh_config.json"
check_diff "$HOME/.config/tmux/tmux.conf" "./dot_config_tmux_tmux.conf"
check_diff "$HOME/.config/kitty/theme.conf" "./dot_config_kitty_theme.conf"
check_diff "$HOME/.config/yazi/Catppuccin-mocha.tmTheme" "./dot_config_yazi/Catppuccin-mocha.tmTheme"
check_diff "$HOME/.config/yazi/theme.toml" "./dot_config_yazi/theme.toml"
check_diff "$HOME/.config/Code/extensions/.vscode/extensions.json" "./vscode_extensions.json"
check_diff "$HOME/.zsh_plugins.txt" "./dot_zsh_plugins.txt"


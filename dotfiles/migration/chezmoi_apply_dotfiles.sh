# apply all tracked files

# chezmoi apply ~/.bashrc
# chezmoi apply ~/.vimrc
# chezmoi apply ~/.zshrc
# chezmoi apply ~/.config/bat/config
# chezmoi apply ~/.config/Code/User/settings.json
# chezmoi apply ~/.config/git/config
# chezmoi apply ~/.config/kitty/kitty.conf
# chezmoi apply ~/.config/lazygit/config.yml
# chezmoi apply ~/.config/mise/config.toml
# chezmoi apply ~/.config/oh-my-posh/config.json
# chezmoi apply ~/.config/tmux/tmux.conf
# chezmoi apply ~/.config/kitty/theme.conf
# chezmoi apply ~/.config/yazi
# chezmoi apply ~/.config/Code/extensions/.vscode/extensions.json
# chezmoi apply ~/.zsh_plugins.txt

# List all managed files by chezmoi
# chezmoi managed
chezmoi -v apply

# check
ls -la ~/.bashrc
ls -la ~/.vimrc
ls -la ~/.zshrc
ls -la ~/.config/bat/config
ls -la ~/.config/Code/User/settings.json
ls -la ~/.config/git/config
ls -la ~/.config/kitty/kitty.conf
ls -la ~/.config/lazygit/config.yml
ls -la ~/.config/mise/config.toml
ls -la ~/.config/oh-my-posh/config.json
ls -la ~/.config/tmux/tmux.conf
ls -la ~/.config/kitty/theme.conf
ls -la ~/.config/yazi
ls -la ~/.config/Code/extensions/.vscode/extensions.json
ls -la ~/.zsh_plugins.txt

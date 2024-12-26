alias gc='gcloud'
alias nv='nvim'
alias pev='open $HOME/.local/bin/pev.html'
alias ld='lazydocker'
alias q='exit'
alias e='exit'
alias o='open'
alias c='clear'
alias cc='clipcopy'
alias cp='clippaste'
alias ef='env | fzf'
alias efc='env | fzf | clipcopy'
alias hfc='history | fzf | clipcopy'

srm() {
  gio trash $1
}

# https://github.com/jesseduffield/lazygit?tab=readme-ov-file#changing-directory-on-exit
lg() {
  export LAZYGIT_NEW_DIR_FILE=~/.lazygit/newdir
  lazygit "$@"
  if [ -f $LAZYGIT_NEW_DIR_FILE ]; then
    cd "$(cat $LAZYGIT_NEW_DIR_FILE)"
    rm -f $LAZYGIT_NEW_DIR_FILE > /dev/null
  fi
}

typeset -U path cdpath fpath manpath

# for profile in ${(z)NIX_PROFILES}; do
#   fpath+=($profile/share/zsh/site-functions $profile/share/zsh/$ZSH_VERSION/functions $profile/share/zsh/vendor-completions)
# done

# HELPDIR="/nix/store/m7l6yzmflrf9hjs8707lk9nkhi6f73n1-zsh-5.9/share/zsh/$ZSH_VERSION/help"
HELPDIR="$HOME/.nix-profile/share/zsh/5.9/help"

# antidote in the end is the superior choice. Below is the problem with others plugins manager
# zinit has problem with completion 
# OMZ need to git clone to download external completion

## home-manager/antidote begin :
# Cache resides at : ~/.cache/antidote
# antidote.zsh at : /home/tung/.nix-profile/share/antidote/antidote.zsh


## home-manager/antidote end
source "$HOME/.nix-profile/share/antidote/antidote.zsh"
antidote load "$HOME/.zsh_plugins.txt"


# Oh-My-Zsh/Prezto calls compinit during initialization,
# calling it twice causes slight start up slowdown
# as all $fpath entries will be traversed again.
autoload -U compinit && compinit


# History options should be set in .zshrc and after oh-my-zsh sourcing.
# See https://github.com/nix-community/home-manager/issues/177.
HISTSIZE="10000"
SAVEHIST="10000"

HISTFILE="$HOME/.zsh_history"
mkdir -p "$(dirname "$HISTFILE")"

setopt HIST_FCNTL_LOCK
unsetopt APPEND_HISTORY
unsetopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_EXPIRE_DUPS_FIRST
setopt SHARE_HISTORY
unsetopt EXTENDED_HISTORY

# Need to press esc to enter `zsh-vi-mode`
# tmux vi mode doesn't have the same functionality
# clipboard integration is in progress
ZVM_VI_INSERT_ESCAPE_BINDKEY=jj
source ~/.nix-profile/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
if [[ $options[zle] = on ]]; then
  fzf_bin=$(which fzf)
  zvm_after_init_commands+=("eval \"\$($fzf_bin --zsh)\"")
fi

source <(fzf --zsh)
export FZF_CTRL_T_COMMAND="fd --type f"
export FZF_DEFAULT_OPTS="--color bg:#1e1e2e,bg+:#313244,fg:#cdd6f4,fg+:#cdd6f4,header:#cba6f7,hl:#cba6f7,hl+:#cba6f7,info:#cba6f7,marker:#cba6f7,pointer:#cba6f7,prompt:#cba6f7,spinner:#f5e0dc"
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :300 {}'"
export FZF_TMUX=1

# recommended fzf tab config at : https://github.com/Aloxaf/fzf-tab?tab=readme-ov-file#Configure
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} # Example of how to escape nix variable
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

eval "$(zoxide init zsh --cmd cd)"

# Initialize yazi like documentation : https://yazi-rs.github.io/docs/quick-start#shell-wrapper
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

eval "$(oh-my-posh init zsh --config /home/tung/.config/oh-my-posh/config.json)"

eval "$(mise activate zsh)"

if test -n "$KITTY_INSTALLATION_DIR"; then
  export KITTY_SHELL_INTEGRATION="no-rc"
  autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
  kitty-integration
  unfunction kitty-integration
fi

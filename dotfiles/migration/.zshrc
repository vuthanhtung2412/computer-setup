alias gc='gcloud'
alias nv='nvim'
alias pev='open $HOME/.local/bin/pev.html'
alias xc='xclip -selection clipboard' # copy command output to clipboard
alias xp='xclip -selection clipboard -o' # paste from clipboard
alias ld='lazydocker'
alias q='exit'
alias e='exit'
alias o='open'
alias c='clear'

smr() {
  mv "$1" ~/.local/share/Trash/files/
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

for profile in ${(z)NIX_PROFILES}; do
  fpath+=($profile/share/zsh/site-functions $profile/share/zsh/$ZSH_VERSION/functions $profile/share/zsh/vendor-completions)
done

HELPDIR="/nix/store/m7l6yzmflrf9hjs8707lk9nkhi6f73n1-zsh-5.9/share/zsh/$ZSH_VERSION/help"



## home-manager/antidote begin :
source /nix/store/3i15i9zsp210vziddbz50bm17rgy2vml-antidote-1.9.7/share/antidote/antidote.zsh


bundlefile=/nix/store/c28bwmymk51a33mykwaas7m3sr4vrv16-hm_antidote-files
zstyle ':antidote:bundle' file $bundlefile
staticfile=/tmp/tmp_hm_zsh_plugins.zsh-c28bwmymk51a33mykwaas7m3sr4vrv16
zstyle ':antidote:static' file $staticfile

antidote load $bundlefile $staticfile

## home-manager/antidote end


# Oh-My-Zsh/Prezto calls compinit during initialization,
# calling it twice causes slight start up slowdown
# as all $fpath entries will be traversed again.
autoload -U compinit && compinit
source /nix/store/a968jwjkiyfqrl3vip547rd7r9xw8g5a-zsh-autosuggestions-0.7.0/share/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=(history)







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


if [[ $options[zle] = on ]]; then
  eval "$(/nix/store/1jyfj7687609l2hjvjj3gs1c29ywbdn7-fzf-0.56.2/bin/fzf --zsh)"
fi

source '/nix/store/wa4jqfr9qjh453yikaa917cc3k0fi673-source/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh'

# Need to press esc to enter `zsh-vi-mode`
# tmux vi mode doesn't have the same functionality
# clipboard integration is in progress
ZVM_VI_INSERT_ESCAPE_BINDKEY=jj
source /nix/store/p5ns74j5ba0xpjrlbjcsqqw5yvp027qk-zsh-vi-mode-0.11.0/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
if [[ $options[zle] = on ]]; then
  fzf_bin=$(which fzf)
  zvm_after_init_commands+=("eval \"\$($fzf_bin --zsh)\"")
fi

# Initialize yazi like documentation : https://yazi-rs.github.io/docs/quick-start#shell-wrapper
# programs.yazi.ZshIntegration is not working correctly since i bind `cd` to `zoxide`
# error : zoxide: no match found
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

detach() {
  if [ -z "$1" ]; then
    echo "Usage: detach <command> [arguments...]"
    return 1
  fi

  nohup "$@" >/dev/null 2>&1 &
  echo "Process detached with PID: $!"
}

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

eval "$(/nix/store/d5iair8lnb59rf2jj8f15hzp7nlhvkh8-zoxide-0.9.6/bin/zoxide init zsh --cmd cd)"

function yy() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

eval "$(/nix/store/zxpic75kbclqqcfndjan7dsr0ilq3615-oh-my-posh-23.20.3/bin/oh-my-posh init zsh --config /home/tung/.config/oh-my-posh/config.json)"

eval "$(/nix/store/41xqi2gp6mc9i1jnx54lr7l1abskixkp-mise-2024.10.8/bin/mise activate zsh)"

if test -n "$KITTY_INSTALLATION_DIR"; then
  export KITTY_SHELL_INTEGRATION="no-rc"
  autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
  kitty-integration
  unfunction kitty-integration
fi

eval "$(/nix/store/irq2506ybbvsnpmb5gflcbg90390bmdg-direnv-2.35.0/bin/direnv hook zsh)"


# Aliases
alias -- eza='eza --icons always --git'
alias -- la='eza -a'
alias -- ll='eza -l'
alias -- lla='eza -la'
alias -- ls=eza
alias -- lt='eza --tree'

# Named Directory Hashes


source /nix/store/b5hrwv6dzypslhg27gpqwjg8s5gksakh-zsh-syntax-highlighting-0.8.0/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_HIGHLIGHTERS+=()





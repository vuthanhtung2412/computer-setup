alias gc='gcloud'

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


# Commands that should be applied only for interactive shells.
[[ $- == *i* ]] || return

HISTCONTROL=erasedups:ignoredups:ignorespace
HISTFILESIZE=2000
HISTSIZE=1000

shopt -s histappend
shopt -s checkwinsize
shopt -s extglob
shopt -s globstar
shopt -s checkjobs

alias eza='eza --icons always --git'
alias la='eza -a'
alias ll='eza -l'
alias lla='eza -la'
alias ls=eza
alias lt='eza --tree'

if [[ ! -v BASH_COMPLETION_VERSINFO ]]; then
  . "/nix/store/0zmgwbn1h48qrk6xn3qdbj2xm8vpk1n7-bash-completion-2.14.0/etc/profile.d/bash_completion.sh"
fi

eval "$(/nix/store/d5iair8lnb59rf2jj8f15hzp7nlhvkh8-zoxide-0.9.6/bin/zoxide init bash --cmd cd)"

if [[ :$SHELLOPTS: =~ :(vi|emacs): ]]; then
  eval "$(/nix/store/1jyfj7687609l2hjvjj3gs1c29ywbdn7-fzf-0.56.2/bin/fzf --bash)"
fi

function yy() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

eval "$(/nix/store/zxpic75kbclqqcfndjan7dsr0ilq3615-oh-my-posh-23.20.3/bin/oh-my-posh init bash --config /home/tung/.config/oh-my-posh/config.json)"

eval "$(/nix/store/41xqi2gp6mc9i1jnx54lr7l1abskixkp-mise-2024.10.8/bin/mise activate bash)"

if test -n "$KITTY_INSTALLATION_DIR"; then
  export KITTY_SHELL_INTEGRATION="no-rc"
  source "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"
fi

eval "$(/nix/store/irq2506ybbvsnpmb5gflcbg90390bmdg-direnv-2.35.0/bin/direnv hook bash)"


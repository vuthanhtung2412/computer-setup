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



if [[ ! -v BASH_COMPLETION_VERSINFO ]]; then
  . "/nix/store/0zmgwbn1h48qrk6xn3qdbj2xm8vpk1n7-bash-completion-2.14.0/etc/profile.d/bash_completion.sh"
fi

if test -n "$KITTY_INSTALLATION_DIR"; then
  export KITTY_SHELL_INTEGRATION="no-rc"
  source "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"
fi


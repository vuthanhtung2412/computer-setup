alias gc='gcloud'
alias nv='nvim'
alias pev='open $HOME/.local/bin/pev.html'
alias ld='lazydocker'
alias q='exit'
alias e='exit'
alias o='open'
alias c='clear'
alias -- cc='xclip -selection clipboard' # copy command output to clipboard
alias -- cp='xclip -selection clipboard -o' # paste from clipboard
alias ef='env | fzf'
alias efc='env | fzf | cc'
alias hfc='history | fzf | cp'

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

eval "$(fzf --bash)"
export FZF_CTRL_T_COMMAND="fd --type f"
export FZF_DEFAULT_OPTS="--color bg:#1e1e2e,bg+:#313244,fg:#cdd6f4,fg+:#cdd6f4,header:#cba6f7,hl:#cba6f7,hl+:#cba6f7,info:#cba6f7,marker:#cba6f7,pointer:#cba6f7,prompt:#cba6f7,spinner:#f5e0dc"
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :300 {}'"
export FZF_TMUX=1

eval "$(zoxide init bash --cmd cd)"

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

eval "$(oh-my-posh init bash --config /home/tung/.config/oh-my-posh/config.json)"
eval "$(mise activate bash)"

# eza set up
alias -- eza='eza --icons always --git'
alias -- la='eza -a'
alias -- ll='eza -l'
alias -- lla='eza -la'
alias -- ls=eza
alias -- lt='eza --tree'

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

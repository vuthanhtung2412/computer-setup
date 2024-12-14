{
  config,
  pkgs,
  ...
}:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history = {
      ignoreDups = false; # Corresponds to HIST_IGNORE_DUPS
      ignoreAllDups = true; # Corresponds to unsetopt HIST_IGNORE_ALL_DUPS
      expireDuplicatesFirst = true; # Corresponds to unsetopt HIST_EXPIRE_DUPS_FIRST
    };
    antidote = {
      enable = true;
      plugins = [
        # Basic
        "Aloxaf/fzf-tab"
        "agkozak/zsh-z"
        "z-shell/zsh-eza"
        "MichaelAquilina/zsh-you-should-use"
        "getantidote/use-omz"
        "ohmyzsh/ohmyzsh path:lib"
        "ohmyzsh/ohmyzsh path:plugins/thefuck"
        "ohmyzsh/ohmyzsh path:plugins/zoxide"
        # Docker + k8s
        "ohmyzsh/ohmyzsh path:plugins/docker"
        "ohmyzsh/ohmyzsh path:plugins/kubectl"
        "ohmyzsh/ohmyzsh path:plugins/kubectx"
        "ohmyzsh/ohmyzsh path:plugins/microk8s"
        "ohmyzsh/ohmyzsh path:plugins/helm"
        # Git
        "ohmyzsh/ohmyzsh path:plugins/gh"
        "ohmyzsh/ohmyzsh path:plugins/git-lfs"
        # Cloud
        "ohmyzsh/ohmyzsh path:plugins/aws"
        "ohmyzsh/ohmyzsh path:plugins/azure"
        "ohmyzsh/ohmyzsh path:plugins/gcloud"
        "ohmyzsh/ohmyzsh path:plugins/terraform"
        # Programming language
        "ohmyzsh/ohmyzsh path:plugins/pip"
        "ohmyzsh/ohmyzsh path:plugins/mvn"
        "ohmyzsh/ohmyzsh path:plugins/golang"
        "ohmyzsh/ohmyzsh path:plugins/rust"
        "ohmyzsh/ohmyzsh path:plugins/npm"
      ];
    };
    initExtraFirst = ''
      alias gc='gcloud'
      alias nv='nvim'
      alias pev='xdg-open $HOME/.config/pev.html'
      alias xc='xclip -selection clipboard' # copy command output to clipboard
      alias xp='xclip -selection clipboard -o' # paste from clipboard
      alias ld='lazydocker'

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
    '';
    initExtra = ''
      # Need to press esc to enter `zsh-vi-mode`
      # tmux vi mode doesn't have the same functionality
      # clipboard integration is in progress
      ZVM_VI_INSERT_ESCAPE_BINDKEY=jj
      source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
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
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS} # Example of how to escape nix variable
      zstyle ':completion:*' menu no
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
      zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
      zstyle ':fzf-tab:*' use-fzf-default-opts yes
      zstyle ':fzf-tab:*' switch-group '<' '>'
    '';
  };
}

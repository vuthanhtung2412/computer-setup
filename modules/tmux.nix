{
  config,
  pkgs,
  ...
}:
{
  programs = {
    tmux = {
      enable = true;
      mouse = true;
      catppuccin = {
        enable = true;
        extraConfig = ''
          # You can check the version of catppuccin/tmux by lurking ~/.config/tmux/tmux.conf file
          # The read README.md from nix derivation to set this up
          set -g @catppuccin_window_status_style "rounded"

          # stop nvim rename window status
          set-option -g allow-rename off

          # by default window text include shell name + file path
          set -g @catppuccin_window_default_text "#{b:pane_current_path}"
          set -g @catppuccin_window_current_text "#{b:pane_current_path}"

          set -g status-left ""
          set -g status-right ""

          # Not necessary since oh my posh and nvim status line got it all
          # set -g status-right "#{E:@catppuccin_status_user}"
          # set -ag status-right "#{E:@catppuccin_status_host}"
        '';
      };
      plugins = with pkgs.tmuxPlugins; [
        sensible
        vim-tmux-navigator
        yank
      ];
      baseIndex = 1;
      terminal = "tmux-256color";
      shell = "${pkgs.zsh}/bin/zsh";
      keyMode = "vi";
      extraConfig = ''
        # Inspire by : https://github.com/dreamsofcode-io/tmux/blob/main/tmux.conf

        # Correct color display (ex: Neovim catppuccin)
        set-option -sa terminal-overrides ",xterm*:Tc"

        # Ctrl b is still my preferred prefix

        # Shift arrow to switch windows
        bind -n S-Left  previous-window
        bind -n S-Right next-window

        # Shift Alt vim keys to switch windows
        bind -n M-H previous-window
        bind -n M-L next-window

        # Split panes into current dir
        bind '"' split-window -v -c "#{pane_current_path}"
        bind % split-window -h -c "#{pane_current_path}"

        # Use Alt-arrow keys without prefix key to switch panes
        bind -n M-Left select-pane -L
        bind -n M-Right select-pane -R
        bind -n M-Up select-pane -U
        bind -n M-Down select-pane -D

        # set vi-mode for yank plugins
        set-window-option -g mode-keys vi
        # keybindings
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      '';
    };
    tmate.enable = true;
  };
}

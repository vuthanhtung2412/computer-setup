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
          # This is because version of catppuccin tmux extensions of nix pkgs < v0.3.0
          set -g @catppuccin_window_left_separator ""
          set -g @catppuccin_window_right_separator " "
          set -g @catppuccin_window_middle_separator " █"
          set -g @catppuccin_window_number_position "right"

          set -g @catppuccin_window_default_fill "number"
          set -g @catppuccin_window_default_text "#W"

          set -g @catppuccin_window_current_fill "number"
          set -g @catppuccin_window_current_text "#W"

          set -g @catppuccin_date_time_text "%H:%M"
          set -g @catppuccin_status_modules_right "directory user host session date_time battery"

          set -g @catppuccin_status_left_separator  " "
          set -g @catppuccin_status_right_separator ""
          set -g @catppuccin_status_fill "icon"
          set -g @catppuccin_status_connect_separator "no"

          set -g @catppuccin_directory_text "#{pane_current_path}"
        '';
      };
      plugins = with pkgs.tmuxPlugins; [
        sensible
        vim-tmux-navigator
        yank
        battery
      ];
      baseIndex = 1;
      terminal = "tmux-256color";
      shell = "${pkgs.zsh}/bin/zsh";
      keyMode = "vi";
      extraConfig = ''
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

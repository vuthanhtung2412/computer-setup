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
          # All options can be found at tmux/docs/reference/configuration.md
          
          set -g @catppuccin_flavor 'mocha'
          set -g @catppuccin_window_status_style "rounded"

          # window default format
          set -g @catppuccin_window_text ' #[fg=green]#{pane_current_command} #[fg=blue]#(echo "#{pane_current_path}" | sed "s|$HOME|~|" | rev | cut -d'/' -f-1 | rev) #[fg=white]'

          # window current format
          set -g @catppuccin_window_current_text ' #[fg=green]#{pane_current_command} #[fg=blue]#(echo "#{pane_current_path}" | sed "s|$HOME|~|" | rev | cut -d'/' -f-3 | rev) #[fg=white]'

          set -g @catppuccin_window_number_color "#{@thm_blue}"
          set -g @catppuccin_window_current_number_color "#{@thm_peach}"
          
          set -g status-left ""
          set -g status-right ""
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

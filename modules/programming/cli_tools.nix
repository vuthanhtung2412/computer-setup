{
  config,
  pkgs,
  nixGL,
  ...
}:
{
  home.packages = with pkgs; [
    neofetch
    jq
    yq
    ffmpeg
    yt-dlp
    fd
    ripgrep
    thefuck
    hurl
    tldr
    xclip
    git
    git-lfs
    gh
    btop
    parallel
    neovim # not defined in programs because LazyVim is based -> config managed by home.file
    delta
    chezmoi
    nettools
    # TODO : need to be installed manually because tailscaled service is non existing
    # tailscale
    # tailscaled
  ];
  programs = {
    bat.enable = true;

    lazygit = {
      enable = true;
      settings = {
        git.paging = {
          colorArg = "always";
          # link https://www.reddit.com/r/neovim/comments/10nfhqa/comment/j68qrsh/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
          pager = "delta --dark --paging=never --syntax-theme base16-256 --diff-so-fancy -s";
        };
      };
    };

    fzf = {
      enable = true;
      tmux.enableShellIntegration = true;
      fileWidgetCommand = "fd --type f";
      fileWidgetOptions = [
        "--preview 'bat --style=numbers --color=always --line-range :300 {}'"
      ];
    };

    oh-my-posh = {
      # I like cattpucin theme better but it doesn't have transient prompt
      # and squeeze command in the same line as context
      # TODO : Write a customize config to get rid of info already provided by tmux (host, user, dir, battery, time). Most important prompt is dev env info and exec time
      enable = true;
      useTheme = "slim";
    };

    yazi.enable = true;

    eza = {
      enable = true;
      git = true;
      icons = "always";
    };
    
    zoxide = {
      enable = true;
      options = [
        "--cmd cd" # This replaces the default 'z' command with 'cd'
      ];
    };

    direnv = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    # chromium={
    #   enable = true;
    #   package = (config.lib.nixGL.wrap pkgs.chromium); # libGL problem with chromium-based browser
    # };
    chromium.enable = true;
  };
}
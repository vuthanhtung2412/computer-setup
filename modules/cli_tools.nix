{
  config,
  pkgs,
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
    fzf
    tldr
    xclip
    git-lfs
    gh
    glab
    btop
    parallel
    neovim # not defined in programs because LazyVim is based -> config managed by home.file
    delta
    chezmoi
    nettools
    lazydocker
    thefuck
    rbw
    # TODO : need to be installed manually because tailscaled service is non existing
    # tailscale
    # tailscaled
  ];
  programs = {
    git = {
      # the config file reside at ~ ~/.config/git/config
      enable = true;
      extraConfig = {
        user = {
          name = "vuthanhtung2412";
          email = "vuthanhtung2016hn@gmail.com";
        };
        credential = {
          "https://gitlab.com".helper = "!glab auth git-credential";
          "https://github.com".helper = "!gh auth git-credential";
        };
        core = {
          excludesfile = "~/.gitignore_global";
        };
        pull = {
          rebase = false;
        };
      };
    };

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

    # terminal status line
    # on the left : OS, user, host, path, status code,
    # on the right : docker, kube, git, az, gcp, aws
    # on the second line :  exec time
    # transient prompt
    oh-my-posh = {
      # I like cattpucin theme better but it doesn't have transient prompt
      # and squeeze command in the same line as context
      # TODO : Write a customize config to get rid of info already provided by tmux (host, user, dir, battery, time). Most important prompt is dev env info and exec time
      enable = true;
      # useTheme = "slim";
      settings = builtins.fromJSON (
        builtins.unsafeDiscardStringContext (builtins.readFile ./tung_omp_theme.json)
      );
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
  };
  services = {
    # TODO:
    # git-sync.enable = true;
    # pbgopy.enable = true;
    # syncthing.enable = true;
  };
}

# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  # TODO: Set your username
  home = {
    username = "your-username";
    homeDirectory = "/home/your-username";
  };

  # Add stuff for your user as you see fit:
  
  #Neovim
  programs.neovim.enable = true;

  # VSCode
  programs.vscode.enable = true;
  programs.vscode.extensions = with pkgs; [
    # Git
    vscode-extensions.github.vscode-pull-request-github
    vscode-extensions.eamodio.gitlens
    vscode-extensions.mhutchie.git-graph
    # Collaborative coding
    vscode-extensions.ms-vscode-remote.remote-ssh
    vscode-extensions.ms-vsliveshare.vsliveshare
  ];

  # Browser
  programs.browserpass.browsers = [
    "firefox"
    "brave"
  ];

  # ZSH
  programs = {
    zsh = {
      enable = true;
      enableAutosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      oh-my-zsh = {
        enable = true;
        theme = "powerlevel10k/powerlevel10k/";
        plugins = [
          "z"
          "history"
          "zsh-vi-mode"
          "notify"
        ];
      };
    };
  };

  # CopyQ
  services.copyq.enable = true;

  home.packages = with pkgs; [ 
    cowsay
    vim
    jq
    yq
    ffmpeg
    fzf
    direnv
    bat
    tmux
    tmate
    yt-dlp
    eza
    fd
    ripgrep
    thefuck
    tldr
    diff-so-fancy
    copyq
    git
    git-lfs
    xclip
    parallel
    # Container related
    docker
    k9s
    docker-compose
    kubectx
    kubectl
    # Warp terminal 
    warp-terminal
    # Obsidian
    obsidian
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}

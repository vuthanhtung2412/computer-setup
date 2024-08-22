{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "<user>"; # TODO : to be replace by $USER
  home.homeDirectory = "<home>"; # TODO : to be replace by $HOME

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

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
    # Language support 
    vscode-extensions.ms-vscode.cpptools-extension-pack
    vscode-extensions.vscjava.vscode-java-pack
    vscode-extensions.golang.go
    vscode-extensions.ecmel.vscode-html-css
    vscode-extensions.christian-kohler.npm-intellisense
    vscode-extensions.ms-vscode.live-server
    vscode-extensions.ms-toolsai.jupyter
    vscode-extensions.ms-python.python
    # TODO : Missing python env manager
    vscode-extensions.njpwerner.autodocstring
    vscode-extensions.rust-lang.rust-analyzer
    vscode-extensions.formulahendry.code-runner
    # formatting
    vscode-extensions.esbenp.prettier-vscode
    vscode-extensions.dbaeumer.vscode-eslint
    # Other tools
    vscode-extensions.ms-azuretools.vscode-docker
    vscode-extensions.ms-kubernetes-tools.vscode-kubernetes-tools
    vscode-extensions.tim-koehler.helm-intellisense
    vscode-extensions.vscodevim.vim
    vscode-extensions.alefragnani.bookmarks
    vscode-extensions.tomoki1207.pdf
    # TODO : Codium AI assistant
    vscode-extensions.streetsidesoftware.code-spell-checker
    vscode-extensions.usernamehw.errorlens
    vscode-extensions.pkief.material-icon-theme
    vscode-extensions.shd101wyy.markdown-preview-enhanced
  ];

  # Browser
  programs.browserpass.browsers = [
    "firefox"
    "brave"
    "chrome"
  ];

  # ZSH
  programs = {
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
    };
  };

  # CopyQ
  services.copyq.enable = true;

  # fzf
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true; 
    tmux.enableShellIntegration = true;
  };

  # oh-my-posh
  programs.oh-my-posh = {
    enable = true;
    useTheme = "slimfat";
    enableBashIntegration = true;
    enableZshIntegration = true; 
  };

  # yazi 
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true; 
  };

  # wezterm
  # TODO : wezterm have nvidia driver problem 
  # programs.wezterm = {
  #   enable = true;
  #   enableBashIntegration = true;
  #   enableZshIntegration = true; 
  # };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    neofetch
    cowsay
    vim
    jq
    yq
    ffmpeg
    direnv
    bat
    tmux
    tmate
    yt-dlp
    eza
    ripgrep
    thefuck
    tldr
    diff-so-fancy
    z-lua
    zoxide
    git
    git-lfs
    htop
    xclip
    parallel
    chezmoi
    ulauncher
    # Container related
    # Problem with services with Nix (Non NixOS) https://discourse.nixos.org/t/how-to-run-docker-daemon-from-nix-not-nixos/43413
    # Docker needed to be patch with apt or dnf
    # TODO : Not working in linux yet
    # docker
    # k9s
    # docker-compose
    # kubectx
    # kubectl
    # warp-terminal # TODO : Not working in linux yet
    # Obsidian
    obsidian
    # Prgramming languages 
    python312
    jdk22
    go
    rustc
    cargo
    rustfmt 
    clippy
    libgcc
    nodejs_22
    # Language tools 
    python312Packages.jupyterlab
    python312Packages.notebook
    python312Packages.pip
    maven
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/thanhtung/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

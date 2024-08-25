{ config, pkgs, ... }:

let 
  nixGL = import ./nixGL.nix { inherit pkgs config; };
in {
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


  # VSCode
  programs.vscode = {
    enable = true;
    extensions = with pkgs; [
      # Git
      vscode-extensions.github.vscode-pull-request-github
      vscode-extensions.eamodio.gitlens
      vscode-extensions.mhutchie.git-graph
      # Collaborative coding
      vscode-extensions.ms-vsliveshare.vsliveshare
      vscode-extensions.ms-vscode-remote.remote-ssh
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
      vscode-extensions.bbenoist.nix
      vscode-extensions.formulahendry.code-runner
      # formatting
      vscode-extensions.esbenp.prettier-vscode
      vscode-extensions.dbaeumer.vscode-eslint
      # Other tools
      vscode-extensions.ms-azuretools.vscode-docker
      vscode-extensions.tim-koehler.helm-intellisense
      vscode-extensions.ms-kubernetes-tools.vscode-kubernetes-tools
      vscode-extensions.catppuccin.catppuccin-vsc
      vscode-extensions.vscodevim.vim
      vscode-extensions.tomoki1207.pdf
      vscode-extensions.streetsidesoftware.code-spell-checker
      vscode-extensions.usernamehw.errorlens
      vscode-extensions.pkief.material-icon-theme
      vscode-extensions.shd101wyy.markdown-preview-enhanced
      vscode-extensions.continue.continue
    ];
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    neofetch
    cowsay
    jq
    yq
    ffmpeg
    direnv
    bat
    tmux
    tmate
    yt-dlp
    ripgrep
    thefuck
    tldr
    diff-so-fancy
    z-lua
    zoxide
    xclip
    git
    git-lfs
    htop
    parallel
    vim
    neovim
    chezmoi
    # ulauncher # ulauncher `launch on login` is not working and missing cask
    # Prgramming languages 
    python312
    jdk22
    go
    rustc
    cargo
    rustfmt 
    clippy
    gcc13
    nodejs_22
    # Language tools 
    python312Packages.jupyterlab
    python312Packages.notebook
    python312Packages.pip
    maven
    # Container related 
    # Services problem with Nix (Non NixOS) https://discourse.nixos.org/t/how-to-run-docker-daemon-from-nix-not-nixos/43413
    # Docker needed to be patched with apt or dnf
    # TODO : Install Docker and microk8s and docker desktop via command line
    kubectl 
    kubectx
    k9s
    kubernetes-helm
    # Warp terminal
    (nixGL warp-terminal)
    # Obsidian
    obsidian
    # Zoom
    # TODO : Zoom is not working when installed by Nix yet. https://github.com/NixOS/nixpkgs/issues/267663
    # zoom-us 

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # TODO : the code below is not workings. Tested with fc-list | grep FantasqueSansMono 
    # (pkgs.nerdfonts.override { fonts = [ 
    #   "FantasqueSansMono"
    #   "JetBrainsMono"
    # ];})

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  programs = {    
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      antidote = {
        enable = true;
        plugins =[
          "Aloxaf/fzf-tab"
          "agkozak/zsh-z"
          "z-shell/zsh-eza"
          "jeffreytse/zsh-vi-mode"
        ];
      };
      initExtra = ''
      if [[ $options[zle] = on ]]; then
        fzf_bin=$(which fzf)
        zvm_after_init_commands+=("eval \"\$($fzf_bin --zsh)\"")
      fi
      '';
    };
    fzf = {
      enable = true;
      enableZshIntegration = false; 
      tmux.enableShellIntegration = true;
    };
    oh-my-posh = {
      enable = true;
      useTheme = "slim";
      enableZshIntegration = true; 
    };
    wezterm = {
      enable = true;
      package = (nixGL pkgs.wezterm);
      enableZshIntegration = true; 
    };
    yazi = {
      enable = true;
      enableZshIntegration = true; 
    };
    eza = {
      enable = true;
      enableZshIntegration = true; 
      icons = true;
    };
    chromium = {
      enable = true;
      package = (nixGL pkgs.chromium);
    };
  };

  # CopyQ
  services.copyq.enable = true;

  # Window manager 
  xsession.windowManager.i3.enable = true;

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
  programs.home-manager.enable = true;  # Import external modules
  imports = [ ./options.nix ];

  # This option `"${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL"` needs to be built with home manager impure options
  nixGLPrefix = "${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL";
  
  # nixGLPrefix = "${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel";
}

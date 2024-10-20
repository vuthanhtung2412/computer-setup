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
      # supportCuda = true;
    };
  };


  # VSCode
  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    # mutableExtensionsDir = false;
    userSettings = {
      "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Font'";
      "workbench.iconTheme" = "material-icon-theme";
      "git.confirmSync" = false;
      "git.suggestSmartCommit" = false;
      "workbench.colorTheme" = "Catppuccin Mocha";
    };
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
      vscode-extensions.ms-python.debugpy
      vscode-extensions.ms-python.vscode-pylance
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
      # vscode-extensions.vscodevim.vim # vim in vscode is pretty shit better trying to swtich to neovim
      vscode-extensions.tomoki1207.pdf
      vscode-extensions.streetsidesoftware.code-spell-checker
      vscode-extensions.usernamehw.errorlens
      vscode-extensions.pkief.material-icon-theme
      vscode-extensions.shd101wyy.markdown-preview-enhanced
      vscode-extensions.continue.continue
      vscode-extensions.tailscale.vscode-tailscale
      # TODO : extensions for SQL tools are not available 
      # I have tried the syntax below and failed, it doesn't work like python 
      # qwtel.sqlite-viewer
    ];
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    albert
    neofetch
    cowsay
    jq
    yq
    ffmpeg
    bat
    yt-dlp
    ripgrep
    thefuck
    tldr
    diff-so-fancy
    z-lua
    xclip
    git
    git-lfs
    gh
    btop
    parallel
    neovim
    chezmoi
    nettools
    ibus-engines.bamboo 
    # Prgramming languages 
    # The reason why python needs to bedeclared this way is similar to that of VSCode
    # Link : https://www.reddit.com/r/NixOS/comments/qx490o/install_a_python_package_on_nixos_but_it_is_not/
    (python311.withPackages(p: with p; [
      pip
      #######################
      # Jupyter Environment #
      #######################
      jupyterlab            # Modern interactive development environment for notebooks, code, and data
      notebook              # Original web-based notebook interface
      ipykernel             # IPython kernel for Jupyter
      ipywidgets            # Interactive HTML widgets for Jupyter notebooks

      ################################
      # Core Data Processing & Analysis
      ################################
      numpy                 # Fundamental package for numerical computations, provides powerful N-dimensional array object
      pandas                # Data manipulation and analysis library, provides DataFrame objects

      ###########################
      # Machine Learning and AI #
      ###########################
      torch-bin             # PyTorch: Deep learning framework with strong GPU acceleration
      scikit-learn          # Traditional machine learning algorithms (classification, regression, clustering)

      ######################
      # Data Visualization #
      ######################
      matplotlib            # Comprehensive library for creating static, animated, and interactive visualizations

      #####################
      # Development Tools #
      #####################
      pylint                # Static code analyzer and linter
      # pytest                # Testing framework
    ]))
    jdk22
    go
    rustc
    cargo
    rustfmt 
    clippy
    gcc13
    nodejs_22
    # Language tools 
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
    # OBS studio 
    (nixGL obs-studio)
    # tailscale
    # TODO : need to be installed manually because tailscaled service is non existing
    # tailscale
    # tailscaled
    # Cloud related tools 
    awscli2
    azure-cli
    google-cloud-sdk-gce
    terraform
    # SQL tools
    sqlite-interactive
    # NOTICE : for postgres it is easier to spin up a docker container and turn it off 
    # postgresql_16_jit

    # CUDA tool
    # cudaPackages_12_1.cudatoolkit
    # autoAddDriverRunpath
    # linuxPackages.nvidia_x11

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
      history = {
        ignoreDups = false;        # Corresponds to HIST_IGNORE_DUPS
        ignoreAllDups = true;    # Corresponds to unsetopt HIST_IGNORE_ALL_DUPS
        expireDuplicatesFirst = true;  # Corresponds to unsetopt HIST_EXPIRE_DUPS_FIRST
      };
      antidote = {
        enable = true;
        plugins =[
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
      initExtra = ''
      # Need to press esc to enter `zsh-vi-mode`
      # tmux vi mode doesn't have the same functionality
      source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
      if [[ $options[zle] = on ]]; then
        fzf_bin=$(which fzf)
        zvm_after_init_commands+=("eval \"\$($fzf_bin --zsh)\"")
      fi
      '';
      initExtraFirst = ''
      alias gc='gcloud'
      export PATH=/usr/local/cuda/bin:$PATH
      '';
    };
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
    tmate = {
      enable = true;
    };
    fzf = {
      enable = true;
      tmux.enableShellIntegration = true;
    };
    oh-my-posh = {
      # I like cattpucin theme better but it doesn't have transient prompt 
      # and squeeze command in the same line as context
      # TODO : Write a customize config to get rid of info already provided by tmux (host, user, dir, battery, time). Most important prompt is dev env info and exec time
      enable = true;
      useTheme = "slim";
    };
    vim = {
      enable = true;
    };
    wezterm = {
      enable = true;
      package = (nixGL pkgs.wezterm);
      extraConfig = ''
      return {
        color_scheme = "Catppuccin Mocha",
      }
      '';
    };
    yazi = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true; 
    };
    eza = {
      enable = true;
      git = true;
      icons = true;
    };
    zoxide = {
      enable = true;
      options = [
        "--cmd cd"  # This replaces the default 'z' command with 'cd'
      ];
    };
    direnv = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
    chromium = {
      enable = true;
      package = (nixGL pkgs.chromium);
    };
  };

  # CopyQ
  services = {
    copyq.enable = true; # it is a must for Albert clipboard extension
    # fusuma for touchpad gesture
    fusuma = {
      enable = true;
      settings = {
        # Ctrl plus/minus for 2 fingers pinch is not ideal
        # Limitation of pinch to zoom in xserver : https://www.reddit.com/r/firefox/comments/wtdb7d/pinch_to_zoom_not_working_on_ubuntu/ 
        # TODO : web browser zoom experience on x11 https://gitlab.freedesktop.org/xorg/xserver/-/merge_requests/530
        threshold = {
          swipe = 0.1;
          pinch = 0.1;
        };
        interval = {
          swipe = 1;
          pinch = 0.2;
        };
        swipe = {
          "3" = {
            begin= {
              command = "xdotool keydown Alt";
            };
            right = {
              update = {
                command = "xdotool key Tab";
                interval = 4;
              };
            };
            left = {
              update = {
                command = "xdotool key Shift+Tab";
                interval = 4;
              };
            };
            end = {
              command = "xdotool keyup Alt";
            };
          };
          "4" = {
            left = {
              command = "xdotool key ctrl+alt+Right";
            };
            right = {
              command = "xdotool key ctrl+alt+Left";
            };
            up = {
              command = "xdotool key super+s";
            };
            down = {
              command = "xdotool key Escape && xdotool key super+d";
            };
          };
        };
        pinch = {
          "2" = {
            # Use in conjunction with mouse-pinch-to-zoom
            "in" = { # Zoom out
              # command = "xdotool keydown ctrl key minus keyup ctrl";
              # OR 
              command = "xdotool keydown ctrl click 5 keyup ctrl";
            };
            out = {
              # command = "xdotool keydown ctrl key plus keyup ctrl";
              # OR
              command = "xdotool keydown ctrl click 4 keyup ctrl";
            };
          };
          "3" = {
            "in" = {
              command = "xdotool key super+Down";
            };
            out = {
              command = "xdotool key super+Up";
            };
          };
        };
      };
    };
  };
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

    ".tung".text = ''
    this is a test
    '';
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
    # fix the problem of dynamic link in python package
    # Link : https://discourse.nixos.org/t/what-package-provides-libstdc-so-6/18707
    # This global env var interfere with some programs such as `ubuntu-drivers`
    # LD_LIBRARY_PATH="${pkgs.stdenv.cc.cc.lib}/lib/"; 
    # LD_LIBRARY_PATH = with pkgs; lib.makeLibraryPath [
    #   stdenv.cc.cc
    #   cudaPackages.cudatoolkit
    #   cudaPackages.cudnn
    # ];

    # CUDA_PATH = "${pkgs.cudaPackages.cudatoolkit}";
    # EXTRA_LDFLAGS = "-L${pkgs.cudaPackages.cudatoolkit}/lib";
    # EXTRA_CCFLAGS = "-I${pkgs.cudaPackages.cudatoolkit}/include";
    # CUDA_HOME = "${pkgs.cudaPackages.cudatoolkit}";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;  # Import external modules
  imports = [ 
    ./options.nix 
  ];

  catppuccin.flavor = "mocha";
  catppuccin.enable = true;

  # This option `"${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL"` needs to be built with home manager impure options
  # nixGLPrefix = "${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL";
  
  nixGLPrefix = "${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel";
}

{ config, pkgs, ... }:

let 
  nixGL = import ./nixGL.nix { inherit pkgs config; };
  neovim-10 = pkgs.neovim-unwrapped.overrideAttrs (old: {
    version = "0.10.2";
    src = pkgs.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "v0.10.2";  # or use a commit hash
      sha256 = "+qjjelYMB3MyjaESfCaGoeBURUzSVh/50uxUqStxIfY="; # Leave empty first, Nix will tell you the correct hash
    };
  });
in {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "tung"; # TODO : to be replace by $USER
  home.homeDirectory = "/home/tung"; # TODO : to be replace by $HOME

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
    blueman # linux bluetooth is pretty dogshit
    neofetch
    cowsay
    jq
    yq
    ffmpeg
    yt-dlp
    fd # this is added since many programs such as yazi, fzf and ulauncher depends on it to find files and dir
    ripgrep
    thefuck
    hurl
    tldr
    z-lua
    xclip
    git
    git-lfs
    gh
    btop
    parallel
    neovim-10 # not in programs because LazyVim is based -> config managed by home.file
    delta
    chezmoi
    nettools
    ibus-engines.bamboo 
    xournalpp # pdf annotate tools
    #########################
    # Programming languages #
    #########################
    # This contains only the most lightweight for global setup more specific 
    (python311.withPackages (ps: with ps; [ # this is solely for albert plugins installation, and it also make sense since python is a scripting languages
      pip
    ])) 
    # jdk22
    # go
    # rustc
    # cargo
    # nodejs_22
    # Programming languages tools (linter, LSP)
    # rustfmt
    # clippy
    # ruff
    # gopls
    # sqlfluff
    #####################
    # Container related # 
    #####################
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
    # (nixGL obs-studio) # 24.11 fucks up obs studio somehow
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
        export PATH=/usr/local/cuda/bin:$PATH
      '';
      initExtra = ''
        # Need to press esc to enter `zsh-vi-mode`
        # tmux vi mode doesn't have the same functionality
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

    bash = {
      enable = true;
      historyControl = [
        "erasedups"
        "ignoredups"
        "ignorespace"
      ];
      historyFileSize = 2000;
      historySize = 1000;
      bashrcExtra = ''
        alias gc='gcloud'
        export PATH=/usr/local/cuda/bin:$PATH

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
    tmate.enable = true;
    mise = {
      # `mise implode` to purge every thing
      # `mise prune` to gc (state of every cofig file is kept in `~/.local/state/mise/tracked-configs` so it is good)
      enable = true;
      globalConfig = {
        tools = {
          # I prefer all quick tests is organized in to a dir
          # python = "3.12";
          # java = "21";
          # rust = "1.81";
          # go = "1.22";
          # node = "lts";
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
    vim = {
      enable = true;
      extraConfig = ''
        " Enable system clipboard integration
        set clipboard=unnamedplus

        " Character deletion won't send to clipboard
        nnoremap x "_x
        vnoremap x "_x
        nnoremap X "_X
        vnoremap X "_X

        " Line numbers configuration
        set number          " Show current line number
        set relativenumber  " Show relative line numbers

        " Some recommended additions:
        " Enable syntax highlighting
        syntax on
        
        " Highlight current line
        set cursorline
        
        " Enable mouse support
        set mouse=a
        
        " Show command in bottom bar
        set showcmd
        
        " Highlight matching brackets
        set showmatch
        
        " Search as characters are entered
        set incsearch
        
        " Highlight search matches
        set hlsearch
        
        " Case insensitive search unless capital letter is used
        set ignorecase
        set smartcase

        " Map jj to Escape in insert mode
        inoremap jj <Esc>

        " vim diff is not readable in wezterm
        " link : https://stackoverflow.com/questions/2019281/load-different-colorscheme-when-using-vimdiff
        if &diff
          " colorscheme evening
          highlight DiffAdd    cterm=bold ctermfg=15 ctermbg=60 gui=none guifg=White guibg=#313244
          highlight DiffDelete cterm=bold ctermfg=15 ctermbg=89 gui=none guifg=White guibg=#C74F81
          highlight DiffChange cterm=bold ctermfg=15 ctermbg=60 gui=none guifg=White guibg=#313244
          highlight DiffText   cterm=bold ctermfg=15 ctermbg=89 gui=none guifg=White guibg=#C74F81
        endif
      '';
    };

    # Kittt creator is not very nice but it doesn't send any telemetry 
    # https://github.com/kovidgoyal/kitty/issues/3802
    kitty = {
      enable = true;
      package = (nixGL pkgs.kitty);
    };

    yazi = {
      enable = true;
    };
    eza = {
      enable = true;
      git = true;
      icons = "always";
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
    ".tung_source" = {
      source = ./dotfiles/tung_source;
      recursive = true;
    };
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
    EDITOR = "nvim";
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

{
  config,
  pkgs,
  nixGL,
  ...
}:

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
  home.stateVersion = "24.11"; # Please read the comment before changing.

  nixGL.packages = nixGL.packages;

  # use this instead of "nvidia" because my nvidia GPU is a secondary GPU while the integrated Intel one in the primary
  nixGL.defaultWrapper = "mesa";
  nixGL.offloadWrapper = "nvidiaPrime";

  catppuccin.flavor = "mocha";
  catppuccin.enable = true;

  nixpkgs = {
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
      allowUnfreePredicate = (pkg: true);
    };
  };

  imports = [
    ../modules/bash.nix
    ../modules/cli_tools.nix
    ../modules/devops_tools.nix
    ../modules/hello_world.nix
    ../modules/linux_desktop_apps.nix
    ../modules/linux_term_emulators.nix
    ../modules/programming_langs.nix
    ../modules/tmux.nix
    ../modules/vim.nix
    ../modules/vscode.nix
    ../modules/zsh.nix
  ];

  # TODO:
  # dconf.settings
  # example :
  # gsettings set org.gnome.desktop.wm.preferences focus-new-windows 'strict'

  # TODO: (optional)
  # xdg.mime & xdg.mimeApps
  # Set default application to open a file
  
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # Adds the 'hello' command to your environment. It prints a friendly
    # "Hello, world!" when run.
    # hello

    # It is sometimes useful to fine-tune packages, for example, by applying
    # overrides. You can do that directly here, just don't forget the
    # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # fonts?
    # TODO : the code below is not workings. Tested with fc-list | grep FantasqueSansMono
    # (nerdfonts.override { fonts = [
    #   "FantasqueSansMono"
    #   "JetBrainsMono"
    # ];})

    # You can also create simple shell scripts directly inside your
    # configuration. For example, this adds a command 'my-hello' to your
    # environment:
    # (writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true; # Import external modules
    # Example
    # emacs.enable = true;
  };

  services = {
    # Example
    # emacs = {
    #   enable = true;
    #   package = pkgs.emacs25-nox;
    # };
  };

  # for more `services` and `programs` options checkout
  # https://nix-community.github.io/home-manager/options.xhtml

  # i3 is optional, set linux custom shortcut is good enough
  # Super + Q to close current active window
  # Alt + 1/2/3/4 to switch to corresponding desktop
  # Alt + 1 : web
  # Alt + 2 : nvim
  # Alt + 3 : notes
  # Other monitor : chat + music

  # vietnamese keyboard
  # TODO:
  # i18n.inputMethod = {
  #   enabled = "ibus";
  #   ibus.engines = with pkgs.ibus-engines; [
  #     bamboo
  #   ];
  # };

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

    ".tung_source".source = ../dotfiles/tung_source;
    ".config/pev.html".source = ../modules/pev.html;
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
    TERMINAL = "kitty";
  };
}

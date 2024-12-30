{ config, pkgs, ... }:

{
  home.username = "tung"; # TODO : to be replace by $USER
  home.homeDirectory = "/Users/tung"; # TODO : to be replace by $HOME

  home.stateVersion = "24.11"; # Please read the comment before changing.

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (pkg: true);
    };
  };

  imports = [
    ../modules/Mac/cli_tools.nix
    ../modules/Mac/devops_tools.nix
    ../modules/Mac/desktop_app.nix
    ../modules/Mac/term_emulators.nix
    ../modules/Mac/programming_langs.nix
    ../modules/Mac/tmux.nix
    ../modules/Mac/vim.nix
    ../modules/Mac/vscode.nix
    ../modules/Mac/zsh.nix
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    TERMINAL = "kitty";
  };

  programs.home-manager.enable = true; # Import external modules
}

{
  config,
  pkgs,
  ...
}:
{

  home.packages = with pkgs; [
    zsh
    antidote
    zsh-vi-mode
  ];
  home.file.".zshrc".source = ../dotfiles/linux/.zshrc;
  home.file.".zsh_plugins.txt".source = ../dotfiles/linux/dot_zsh_plugins.txt;
}

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
}

{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    antidote
    zsh-vi-mode
  ];
}

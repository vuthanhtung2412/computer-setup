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
  # home.file.".zshrc".source = ../dotfiles/linux/.zshrc;
  # TODO: I don't fucking know why mise and gh doesn't work
  # Completion code reside at $ZSH_CACHE_DIR/completions and other tools seem to work great
  # home.file.".zsh_plugins.txt".source = ../dotfiles/linux/dot_zsh_plugins.txt;
}

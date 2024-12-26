{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    vim
  ];

  home.file.".vimrc".source = ../dotfiles/linux/.vimrc;
}

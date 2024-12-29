{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    vim-full
  ];

  # home.file.".vimrc".source = ../dotfiles/linux/.vimrc;
}

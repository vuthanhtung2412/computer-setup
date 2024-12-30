{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    vim-full
  ];
}

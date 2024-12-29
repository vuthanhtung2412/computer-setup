{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    warp-terminal
    kitty
  ];
}

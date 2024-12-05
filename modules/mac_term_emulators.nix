{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    warp-terminal
  ];
  programs = {
    kitty.enable = true;
  };
}

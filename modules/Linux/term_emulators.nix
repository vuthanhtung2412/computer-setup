{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    (config.lib.nixGL.wrap warp-terminal)
    (config.lib.nixGL.wrap pkgs.kitty)
  ];
}

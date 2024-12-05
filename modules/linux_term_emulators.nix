{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    (config.lib.nixGL.wrap warp-terminal)
  ];
  programs = {
    kitty = {
      enable = true;
      package = (config.lib.nixGL.wrap pkgs.kitty);
    };
  };
}

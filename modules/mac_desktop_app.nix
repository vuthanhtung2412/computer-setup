{
  config,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    raycast
    brave
    xournalpp
    obsidian
    blender
    obs-studio
  ];
}

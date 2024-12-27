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
  # home.file.".config/kitty/kitty.conf".source = ../dotfiles/linux/dot_config_kitty_kitty.conf;
  # home.file.".config/kitty/theme.conf".source = ../dotfiles/linux/dot_config_kitty_theme.conf;
}

{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # TODO: mise zsh competion is not working
    mise
    nixfmt-rfc-style # not available in mason yet
  ];

  # home.file.".config/mise/config.toml".source = ../dotfiles/linux/dot_config_mise_config.toml;
}

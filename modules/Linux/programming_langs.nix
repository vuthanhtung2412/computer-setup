{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # TODO: mise zsh competion is not working
    mise
    (python311.withPackages (
      ps: with ps; [
        # this is solely for albert plugins installation, and it also make sense since python is a scripting languages
        pip
      ]
    ))
    nixfmt-rfc-style # not available in mason yet
  ];

  # home.file.".config/mise/config.toml".source = ../dotfiles/linux/dot_config_mise_config.toml;
}

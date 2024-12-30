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
        pip
      ]
    ))
    nixfmt-rfc-style # not available in mason yet
  ];
}

{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    mise
    nixfmt-rfc-style # not available in mason yet
  ];
}

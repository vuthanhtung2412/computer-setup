{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # TODO: learn how to setup bash-completion
    # bash-completion
  ];
}

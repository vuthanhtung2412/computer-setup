{
  config,
  pkgs,
  ...
}:

{
  home.packages = [
    pkgs.hello
    pkgs.cowsay
  ];
}

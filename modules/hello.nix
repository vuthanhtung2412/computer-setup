{
  config,
  pkgs,
  ...
}:

{
  home.packages = [
    pkgs.hello
  ];
}

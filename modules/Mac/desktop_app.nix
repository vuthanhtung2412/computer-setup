{
  config,
  pkgs,
  ...
}:

{
  home.file.".local/bin/pev.html".source = ./pev.html;
  home.file.".tung-setup/Brewfile".source = ./Brewfile;
}

{
  config,
  pkgs,
  ...
}:

{
  
  home.packages = with pkgs; [
    vscode
  ];
  home.file.".config/Code/User/settings.json".source = ../dotfiles/linux/dot_config_Code_User_settings.json;
  home.file.".config/Code/extensions/.vscode/extensions.json".source = ../dotfiles/linux/vscode_extensions.json;
}

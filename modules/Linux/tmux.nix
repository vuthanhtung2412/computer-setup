{
  config,
  pkgs,
  ...
}:
{

  home.packages = with pkgs; [
    tmux
    tmate
    tmuxPlugins.sensible
    tmuxPlugins.sensible
    tmuxPlugins.vim-tmux-navigator
    tmuxPlugins.resurrect
    tmuxPlugins.yank
    # continuous saving each 15 min
    # prefix + ctrl-s to trigger saving manually
    tmuxPlugins.continuum
    tmuxPlugins.catppuccin
  ];
}

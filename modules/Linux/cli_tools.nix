{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    neofetch
    jq
    yq
    tree
    ffmpeg
    yt-dlp
    fd
    ripgrep
    thefuck
    hurl
    fzf
    tldr
    xclip
    git-lfs
    gh
    glab
    btop
    parallel
    neovim # not defined in programs because LazyVim is based -> config managed by home.file
    delta
    chezmoi
    nettools
    lazydocker
    thefuck
    rbw
    bat
    zoxide
    eza
    oh-my-posh
    yazi
    git
    lazygit
    # TODO : need to be installed manually because tailscaled service is non existing
    # tailscale
    # tailscaled
  ];
  # home.file.".config/bat/config".source = ../dotfiles/linux/dot_config_bat_config;
  # home.file.".config/oh-my-posh/config.json".source = ../dotfiles/linux/dot_config_oh-my-posh_config.json;
  # home.file.".config/git/config".source = ../dotfiles/linux/dot_config_git_config;
  # home.file.".gitignore_global".source = ../dotfiles/linux/dot_gitignore_global;
  # home.file.".config/lazygit/config.yml".source = ../dotfiles/linux/dot_config_lazygit_config.yml;
  # home.file.".config/yazi".source = ../dotfiles/linux/dot_config_yazi;
 
  # chezmoi is an exception since `~/.config/chezmoi/` can't be managed with chezmoi
  home.file.".config/chezmoi/chezmoi.toml".source = ../../dotfiles/linux/dot_config_chezmoi_chezmoi.toml;
  services = {
    # TODO:
    # git-sync.enable = true;
    # pbgopy.enable = true;
    # syncthing.enable = true;
  };
}

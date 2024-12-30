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
    tree # idk why tf this is not installed by default
    ffmpeg # -full
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
  # chezmoi is an exception since `~/.config/chezmoi/` can't be managed with chezmoi
  home.file.".config/chezmoi/chezmoi.toml".source = ../../dot_config_chezmoi_chezmoi.toml;
  services = {
    # TODO:
    # git-sync.enable = true;
    # pbgopy.enable = true;
    # syncthing.enable = true;
  };
}

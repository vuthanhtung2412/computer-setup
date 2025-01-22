{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # TODO: manage brew with nix
    # brew
    jq
    yq
    ffmpeg # -full
    yt-dlp
    fd
    ripgrep
    thefuck
    hurl
    fzf
    tldr
    git-lfs
    gh
    glab
    btop
    parallel
    neovim # not defined in programs because LazyVim is based -> config managed by home.file
    delta
    chezmoi
    lazydocker
    rbw
    bat
    zoxide
    eza
    oh-my-posh
    yazi
    git
    lazygit
    pre-commit
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

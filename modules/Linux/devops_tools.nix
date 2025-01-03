{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # Docker need to be installed manually since nix is bad with services
    # kubenetes related tools
    kubectl
    kubectx
    k9s
    kubernetes-helm
    # Cloud related tools
    awscli2
    azure-cli
    google-cloud-sdk
    terraform
  ];
  services = {
    # TODO:
    # Au lieu de docker since docker requires a deamon
    # podman.enable = true;
  };
}

{
  description = "Home Manager configuration of thanhtung";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "<system>"; # TODO : replace by either [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ]
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations."<user>" = home-manager.lib.homeManagerConfiguration { # TODO : <user> to be replace by $USER env var
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
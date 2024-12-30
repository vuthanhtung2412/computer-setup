{
  description = "Home Manager configuration of thanhtung";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixGL = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, nixGL, ... }:
  let
    system = "<system>"; # TODO : replace by either [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ]
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    homeConfigurations."<user>" = home-manager.lib.homeManagerConfiguration { # TODO : <user> to be replace by $USER env var
      inherit pkgs;
      
      # Specify your home configuration modules here, for example,
      # the path to your home.nix.
      modules = [ 
        ./home.nix 
      ];

      # Optionally use extraSpecialArgs
      extraSpecialArgs = {
        inherit nixGL;
      };
      # to pass through arguments to home.nix
    };
  };
}

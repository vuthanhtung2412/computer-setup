{
  description = "Home Manager configuration of thanhtung";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    catppuccin.url = "github:catppuccin/nix";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl = { url = "github:nix-community/nixGL"; };
  };

  outputs = { nixpkgs, catppuccin, home-manager, nixgl, ... }:
  let
    pkgs = import nixpkgs {
      system = "<system>"; # TODO : replace by either [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ]
      overlays = [ nixgl.overlay ];
    };
  in {
    homeConfigurations."<user>" = home-manager.lib.homeManagerConfiguration { # TODO : <user> to be replace by $USER env var
      inherit pkgs;

      # Specify your home configuration modules here, for example,
      # the path to your home.nix.
      modules = [ 
        ./home.nix 
        catppuccin.homeManagerModules.catppuccin
      ];

      # Optionally use extraSpecialArgs
      # to pass through arguments to home.nix
    };
  };
}

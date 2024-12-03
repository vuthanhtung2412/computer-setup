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
    nixGL = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, catppuccin, home-manager, nixGL, ... }:
  let
    pkgs = import nixpkgs {
      system = "x86_64-linux"; # TODO : replace by either [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ]
      # overlays = [ nixGL.overlay ];
    };
  in {
    homeConfigurations."tung" = home-manager.lib.homeManagerConfiguration { # TODO : tung to be replace by $USER env var
      inherit pkgs;
      
      extraSpecialArgs = {
          inherit nixGL;
      };
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

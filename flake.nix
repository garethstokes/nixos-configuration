{
  description = "Home Manager and NixOS configuration of Gareth";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # icons used for theming
    more-waita = {
      url = "https://github.com/somepaulo/MoreWaita/archive/refs/heads/main.zip";
      flake = false;
    };

    # pretty colours
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = { home-manager, nixpkgs, nixpkgs-master, catppuccin, ... }@inputs:
  let
    username = "gareth";
    hostname = "bandit";
    system = "x86_64-linux";

    pkgs-master = import nixpkgs-master {
      inherit system;
      config.allowUnfree = true;
    };
  in
  {
    nixosConfigurations."${hostname}" = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs username hostname system; };
      modules = [ ./p14s/configuration.nix ];
    };

    homeConfigurations."${username}" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      extraSpecialArgs = { inherit inputs username pkgs-master; };
      modules = [ 
        ./home-manager/home.nix
        catppuccin.homeManagerModules.catppuccin
      ];
    };
  };
}

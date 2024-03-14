{
  description = "Home Manager and NixOS configuration of Gareth";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # icons used for theming
    more-waita = {
      url = "https://github.com/somepaulo/MoreWaita/archive/refs/heads/main.zip";
      flake = false;
    };
  };

  outputs = { home-manager, nixpkgs, ... }@inputs:
  let
    username = "gareth";
    hostname = "bandit";
    system = "x86_64-linux";
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
      extraSpecialArgs = { inherit inputs username; };
      modules = [ ./home-manager/home.nix ];
    };
  };
}

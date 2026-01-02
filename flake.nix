{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:nix-community/stylix";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    abhivim.url = "git+https://codeberg.org/abhirath/nvim";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri-flake = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cachy-tweaks = {
      url = "github:AniviaFlome/cachy-tweaks-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-mineral.url = "github:cynicsketch/nix-mineral/";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        gtx-nix = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/gtx-nix/configuration.nix
            inputs.niri-flake.nixosModules.niri
          ];
        };
        latitude-wsl = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            inputs.nixos-wsl.nixosModules.default
            ./hosts/latitude-wsl/configuration.nix
          ];
        };
      };
    };
}

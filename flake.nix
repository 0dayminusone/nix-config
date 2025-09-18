{
  inputs = {
    # Nixpkgs
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-25.05";
    };
    # Nixpkgs Unstable
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, home-manager, nixpkgs-unstable, ... }@inputs:
  let
    varsConfig = import ./vars/vars.nix;
  in
  {
    ## shittrbox
    nixosConfigurations.main = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
        vars = varsConfig.getHostVars "main";
      };
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
      ];
    };
  };
}


# based on vimjoyer + 
# https://github.com/reckenrode/nixos-configs

# additional inspiration from
# https://tech.aufomm.com/my-nixos-journey-intro-and-installation/
# https://tech.aufomm.com/my-nixos-journey-home-manager/
# https://tech.aufomm.com/my-nixos-journey-flakes/

# apple silicon stuff taken from (among other places):
# https://github.com/yusefnapora/nix-config
#

{
  description = "Givtrah nix config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs?ref=nixos-unstable";

    home-manager.url = "github:nix-community/home-manager?ref=release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    home-manager-unstable.url = "github:nix-community/home-manager";
    home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs-unstable";

    apple-silicon.url = "github:tpwrules/nixos-apple-silicon";

  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, home-manager-unstable, ... }@inputs: {
    nixosConfigurations = {
      taumac = nixpkgs-unstable.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/taumac
          home-manager-unstable.nixosModules.home-manager
        ]; 
      };
    };
  };
}





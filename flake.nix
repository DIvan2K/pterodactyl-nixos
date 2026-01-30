{
  description = "Pterodactyl Wings for NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
  let
    forAllSystems = flake-utils.lib.eachSystem [
      "x86_64-linux"
      "aarch64-linux"
    ];
  in
  {
    nixosModules = rec {
      wings = ./modules/wings;
      default = wings;
    };

    packages = forAllSystems (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        wings = pkgs.callPackage ./pkgs/wings { };
        default = self.packages.${system}.wings;
      }
    );
  };
}

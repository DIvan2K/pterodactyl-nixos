{
  description = "Pterodactyl Wings for NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: 
    flake-utils.lib.eachSystem ["x86_64-linux" "aarch64-linux"] (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages.wings = pkgs.callPackage ./pkgs/wings { };
        nixosModules.wings = import ./modules/wings { };
      }
    );
}

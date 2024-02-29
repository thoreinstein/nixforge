{
  description = "my project description";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixforge.url = "github:thoreinstein/nixforge";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    nixforge,
  }:
    flake-utils.lib.eachDefaultSystem
    (
      system: let
        pkgs = import nixpkgs {
          inherit system;

          # Terraforms new licensing model now requires this
          config.allowUnfree = true;
        };
      in {
        devShells.default = nixforge.cloud.${system}.shell {
          inherit pkgs;
        };
      }
    );
}


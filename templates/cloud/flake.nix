{
  description = "NixForged cloud development environment";

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

          # The new Terraform licensing model now requires this
          config.allowUnfree = true;
        };
      in {
        devShells.default = nixforge.cloud.shell {
          inherit pkgs;

          # Extra build inputs to install
          buildInputs = [];

          # Extra shell hooks to install
          shellHook = "";
        };
      }
    );
}


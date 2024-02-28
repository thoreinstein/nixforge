{
  description = "NixForge - Reusable devShells and neovim configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        neovim = {
          shell = import ./modules/neovim/shell.nix;
          nvim = import ./modules/neovim/lua.nix;
        };
        devShells.default = import ./modules/neovim/shell.nix {inherit pkgs;};
      }
    );
}

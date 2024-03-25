{
  description = "NixForge: Nix shells and neovim configs for fast development environments";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    nixpkgs,
    ...
  }: {
    templates = {
      cloud = {
        path = ./templates/cloud;
        description = ''
          Preconfigured nix shell and neovim config for writing IaC
        '';
      };
      neovim = {
        path = ./templates/neovim;
        description = ''
          Preconfigured nix shell and neovim config for writing lua
        '';
      };
      nixos = {
        path = ./templates/nixos;
        description = ''
          Preconfigured nix shell and neovim config for writing nix
        '';
      };
      rust = {
        path = ./templates/rust;
        description = ''
          Preconfigured nix shell and neovim config for writing rust
        '';
      };
    };
    neovim = {
      shell = import ./modules/neovim/shell.nix;
      lua = import ./modules/neovim/lua.nix;
    };
    cloud = {
      shell = import ./modules/cloud/shell.nix;
      lua = import ./modules/cloud/lua.nix;
    };
    nixos = {
      shell = import ./modules/nixos/shell.nix;
      lua = import ./modules/nixos/lua.nix;
    };
    rust = {
      shell = import ./modules/rust/shell.nix;
      lua = import ./modules/rust/lua.nix;
    };
    devShells.x86_64-linux = let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in {
      default = import ./modules/neovim/shell.nix {inherit pkgs;};
    };
    devShells.aarch64-darwin = let
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;
    in {
      default = import ./modules/neovim/shell.nix {inherit pkgs;};
    };
  };
}

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
    devShells.x86_64-linux = let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in {
      default = import ./modules/neovim/shell.nix {inherit pkgs;};
    };
  };
}

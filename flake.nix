{
  description = "Description for the project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }: {
    templates = {
      cloud = {
        path = ./templates/cloud;
        description = ''
          Preconfigured nix shell and neovim config for writing IaC
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
    devShells.x86_64-linux = let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in {
      default = import ./modules/neovim/shell.nix {inherit pkgs;};
    };
  };
}

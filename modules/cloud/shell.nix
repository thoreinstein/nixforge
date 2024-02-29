{
  pkgs ? import <nixpkgs> { config = { allowUnfree = true; }; },
  buildInputs ? [],
  shellHook ? "",
}: let
  luaFile = pkgs.callPackage ./lua.nix {inherit pkgs;};
  newBuildInputs = buildInputs;
  newShellHook = shellHook;
in
  with pkgs;
    mkShell {
      buildInputs =
        [
          alejandra
          ansible
          ansible-language-server
          luaFile
          kubectl
          terraform
          terraform-ls
          yaml-language-server
        ]
        ++ newBuildInputs;

      shellHook =
        ''
          cp ${luaFile}/.nvim.lua ./

          trap 'rm -f ./.nvim.lua' EXIT
        ''
        + newShellHook;
    }

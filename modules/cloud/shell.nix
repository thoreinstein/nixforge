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
          luaFile
          terraform
          terraform-ls
        ]
        ++ newBuildInputs;

      shellHook =
        ''
          cp ${luaFile}/.nvim.lua ./

          trap 'rm -f ./.nvim.lua' EXIT
        ''
        + newShellHook;
    }

{
  pkgs ? import <nixpkgs> {},
  buildInputs ? [],
  shellHook ? "",
  ...
}:
with pkgs; let
  luaFile = callPackage ./lua.nix {inherit pkgs;};
  newBuildInputs = buildInputs;
  newShellHook = shellHook;
in
  mkShell {
    buildInputs =
      [
        alejandra
        luaFile
        lua-language-server
        stylua
      ]
      ++ newBuildInputs;

    shellHook =
      ''
        cp ${luaFile}/.nvim.lua ./

        trap 'rm -f ./.nvim.lua' EXIT
      ''
      + newShellHook;
  }

{pkgs ? import <nixpkgs> {}}:
with pkgs; let
  luaFile = callPackage ./lua.nix {inherit pkgs;};
in
  mkShell {
    buildInputs = [
      alejandra
      luaFile
      lua-language-server
      stylua
    ];

    shellHook = ''
      cp ${luaFile}/.nvim.lua ./

      trap 'rm -f ./.nvim.lua' EXIT
    '';
  }

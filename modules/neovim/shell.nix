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
        lua_file=".nvim.lua"
        lock_file="/tmp/nixforge-neovim"

        cleanup() {
          if [ -f "$lock_file" ] && [ "$(cat $lock_file)" = "$$" ]; then
            rm -f "$lua_file"
            rm -f "$lock_file"
          fi
        }

        if [ ! -f "$lua_file" ]; then
          cp ${luaFile}/"$lua_file" ./
        fi

        if [ ! -f "$lock_file" ]; then
          echo $$ > "$lock_file"
          trap cleanup EXIT
        fi
      ''
      + newShellHook;
  }

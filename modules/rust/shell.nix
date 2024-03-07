{
  pkgs ? import <nixpkgs> {config = {allowUnfree = true;};},
  buildInputs ? [],
  shellHook ? "",
}: let
  luaFile = pkgs.callPackage ./lua.nix {inherit pkgs;};
  newBuildInputs = buildInputs;
  newShellHook = shellHook;
in
  with pkgs;
    mkShell {
      buildInputs = [alejandra luaFile nil rustfmt] ++ newBuildInputs;

      shellHook =
        ''
          lua_file=".nvim.lua"
          lock_file="/tmp/nixforge-cloud"

          cleanup() {
            if [ -f "$lock_file" ] && [ "$(cat $lock_file)" = "$$" ]; then
              echo "Removing $lock_file and $lua_file"
              rm -f "$lua_file"
              rm -f "$lock_file"
            fi
          }

          if [ ! -f "$lua_file" ]; then
            echo "$lua_file does not exist, copying from ${luaFile}"
            cp ${luaFile}/"$lua_file" ./
          fi

          if [ ! -f "$lock_file" ]; then
            echo "Creating $lock_file with $$"
            echo $$ > "$lock_file"
            trap cleanup EXIT
          fi

        ''
        + newShellHook;
    }

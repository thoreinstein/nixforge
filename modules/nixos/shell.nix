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
      buildInputs = [alejandra luaFile nil codespell nodePackages.bash-language-server nixfmt shellharden];

      shellHook = ''
        lua_file=".nvim.lua"
        lock_file="/tmp/nixforge-cloud"

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
      '';
    }

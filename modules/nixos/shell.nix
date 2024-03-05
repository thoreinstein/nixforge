{ pkgs ? import <nixpkgs> { } }:

with pkgs;

mkShell {
  buildInputs =
    [ nil codespell nodePackages.bash-language-server nixfmt shellharden ];

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


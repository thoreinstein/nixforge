{
<<<<<<< HEAD
  pkgs,
  buildInputs ? [],
||||||| parent of 1f4c332 (WIP)
  pkgs ? import <nixpkgs> {config = {allowUnfree = true;};},
  buildInputs ? [],
=======
  pkgs ? import <nixpkgs> {config = {allowUnfree = true;};},
  packages ? [],
>>>>>>> 1f4c332 (WIP)
  shellHook ? "",
}: let
  luaFile = pkgs.callPackage ./lua.nix {inherit pkgs;};
  newPackages = packages;
  newShellHook = shellHook;
in
  with pkgs;
    mkShell {
<<<<<<< HEAD
      name = "NixForge Cloud Shell";
      buildInputs =
||||||| parent of 1f4c332 (WIP)
      buildInputs =
=======
      packages =
>>>>>>> 1f4c332 (WIP)
        [
          alejandra
          ansible
          ansible-language-server
<<<<<<< HEAD
          beautysh
          luaFile
||||||| parent of 1f4c332 (WIP)
          luaFile
=======
          ansible-lint
          argocd
          cloudflared
          k3sup
>>>>>>> 1f4c332 (WIP)
          kubectl
          kubernetes-helm
<<<<<<< HEAD
          nodePackages_latest.bash-language-server
          shellharden
||||||| parent of 1f4c332 (WIP)
=======
          luaFile
          packer
>>>>>>> 1f4c332 (WIP)
          terraform
          terraform-ls
          yaml-language-server
        ]
        ++ newPackages;

      shellHook =
        ''
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

          alias ta='${pkgs.terraform}/bin/terraform apply'
          alias tay='${pkgs.terraform}/bin/terraform apply -auto-approve'
          alias tc='${pkgs.terraform}/bin/terraform console'
          alias td='${pkgs.terraform}/bin/terraform destroy'
          alias tp='${pkgs.terraform}/bin/terraform plan'
          alias ts='${pkgs.terraform}/bin/terraform state'

          source <(kubectl completion bash)
          source <(helm completion bash)
        ''
        + newShellHook;
    }

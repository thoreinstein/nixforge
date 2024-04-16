{
  pkgs ? import <nixpkgs> {config = {allowUnfree = true;};},
  packages ? [],
  shellHook ? "",
}: let
  luaFile = pkgs.callPackage ./lua.nix {inherit pkgs;};
  newPackages = packages;
  newShellHook = shellHook;
in
  with pkgs;
    mkShell {
      packages =
        [
          alejandra
          ansible
          ansible-language-server
          ansible-lint
          argocd
          cloudflared
          k3sup
          kubectl
          kubernetes-helm
          luaFile
          packer
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

          alias tp="${pkgs.terraform}/bin/terraform plan"
          alias ta="${pkgs.terraform}/bin/terraform apply"
          alias td="${pkgs.terraform}/bin/terraform destroy"
          alias ti="${pkgs.terraform}/bin/terraform init -upgrade"
          alias tc="${pkgs.terraform}/bin/terraform console"

          source <(kubectl completion bash)
          source <(helm completion bash)
        ''
        + newShellHook;
    }

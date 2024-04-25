{
  pkgs,
  packages ? [],
  shellHook ? "",
  name ? "NixForge Cloud Shell",
}: let
  luaFile = pkgs.callPackage ./lua.nix {inherit pkgs;};
  newPackages = packages;
  newShellHook = shellHook;
in
  with pkgs;
    mkShell {
      name = name;
      buildInputs =
        [
          age
          alejandra
          ansible
          ansible-language-server
          ansible-lint
          beautysh
          cloudflared
          k3sup
          kubectl
          kubernetes-helm
          luaFile
          nodePackages_latest.bash-language-server
          shellharden
          terraform
          terraform-ls
          vault
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
          alias tdy='${pkgs.terraform}/bin/terraform destroy -auto-approve'
          alias tp='${pkgs.terraform}/bin/terraform plan'
          alias ts='${pkgs.terraform}/bin/terraform state'
          alias ti='${pkgs.terraform}/bin/terraform init'
          alias tiu='${pkgs.terraform}/bin/terraform init -upgrade'
          alias tf='${pkgs.terraform}/bin/terraform fmt -recursive'

          source <(kubectl completion bash)
          source <(helm completion bash)
        ''
        + newShellHook;
    }

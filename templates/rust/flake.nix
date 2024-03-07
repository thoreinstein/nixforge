{
  description = "NixForged rust development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    naersk.url = "github:nix-community/naersk";
    rust-overlay.url = "github:oxalica/rust-overlay";
    nixforge.url = "github:thoreinstein/nixforge";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    rust-overlay,
    naersk,
    nixforge,
  }:
    flake-utils.lib.eachDefaultSystem
    (
      system: let
        # rust-overlay is imported here to allow you to customize your rust version
        overlays = [(import rust-overlay)];
        pkgs = import nixpkgs {
          inherit system overlays;
        };

        naersk' = pkgs.callPackage naersk {
          cargo = pkgs.rust-bin.stable.latest.cargo;
          rustc = pkgs.rust-bin.stable.latest.rustc;
        };
      in {
        packages = {
          default = naersk'.buildPackage {
            src = ./.;
          };

          check = naersk'.buildPackage {
            src = ./.;
            mode = "check";
          };

          test = naersk'.buildPackage {
            src = ./.;
            mode = "test";
          };

          clippy = naersk'.buildPackage {
            src = ./.;
            mode = "clippy";
          };
        };

        devShells.default = nixforge.rust.shell {
          inherit pkgs;

          # Extra build inputs to install
          buildInputs = with pkgs; [
            (rust-bin.stable.latest.default.override {
              extensions = ["rust-src"];
            })
          ];

          # Extra shell hooks to install
          shellHook = "";
        };
      }
    );
}

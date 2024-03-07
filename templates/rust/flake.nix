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

        toolchain = pkgs.rustChannelOf({
          rustToolchain = ./rust-toolchain;
          sha256 = "";
          #        ^ After you run `nix build`, replace this with the actual
          #          hash from the error message
        }).rust;

        naersk' = pkgs.callPackage naersk {
          cargo = toolchain;
          rustc = toolchain;
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
            toolchain
          ];

          # Extra shell hooks to install
          shellHook = "";
        };
      }
    );
}

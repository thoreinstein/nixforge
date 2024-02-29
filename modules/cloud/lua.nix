{pkgs}:
with pkgs;
  stdenv.mkDerivation {
    name = ".nvim.lua";
    src = ./.;

    installPhase = ''
      mkdir -p $out
      cat lua/*.lua > .nvim.lua
      cp .nvim.lua $out/.nvim.lua
    '';
  }


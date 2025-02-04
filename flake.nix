{
  description =
    ''
      A flake giving access to fonts that I use, outside of nixpkgs,
      from https://github.com/jeslie0/fonts
    '';

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        defaultPackage = pkgs.symlinkJoin {
          name = "custom_fonts-0.1";
          paths = builtins.attrValues
            self.packages.${system}; # Add font derivation names here
        };

        packages.gillsans = pkgs.stdenvNoCC.mkDerivation {
          name = "gillsans-font";
          dontConfigure = true;
          src = pkgs.fetchzip {
            url =
              "https://freefontsvault.s3.amazonaws.com/2020/02/Gill-Sans-Font-Family.zip";
            sha256 = "sha256-YcZUKzRskiqmEqVcbK/XL6ypsNMbY49qJYFG3yZVF78=";
            stripRoot = false;
          };
          installPhase = ''
            mkdir -p $out/share/fonts
            cp -R $src $out/share/fonts/opentype/
          '';
          meta = { description = "A Gill Sans Font Family derivation."; };
        };

        packages.palatino = pkgs.stdenvNoCC.mkDerivation {
          name = "palatino-font";
          dontConfigure = true;
          src = pkgs.fetchzip {
            url =
              "https://www.dfonts.org/wp-content/uploads/fonts/Palatino.zip";
            sha256 = "sha256-FBA8Lj2yJzrBQnazylwUwsFGbCBp1MJ1mdgifaYches=";
            stripRoot = false;
          };
          installPhase = ''
            mkdir -p $out/share/fonts
            cp -R $src/Palatino $out/share/fonts/truetype/
          '';
          meta = { description = "The Palatino Font Family derivation."; };
        };

        packages.nonicons = pkgs.stdenvNoCC.mkDerivation {
          name = "nonicons-font";
          dontConfigure = true;
          dontUnpack = true;
          dontBuild = true;
          src = pkgs.fetchurl {
            url = "https://github.com/ya2s/nonicons/raw/refs/heads/master/dist/nonicons.ttf";
            hash = "sha256-25k4k7IUzmrYO1TF4ErDia1VT0vMxqQZuWviiesU1qc=";
          };
          installPhase = ''
            mkdir -p $out/share/fonts/truetype
            cp $src $out/share/fonts/truetype/nonicons.ttf
          '';
          meta = { description = "Nonicons font"; };
        };
      });
}

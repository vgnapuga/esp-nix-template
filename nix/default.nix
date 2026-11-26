{ nixpkgs, nixpkgs-esp-dev }:
let
  systems = [ "x86_64-linux" "aarch64-linux" ];
  forAllSystems = f:
    nixpkgs.lib.genAttrs systems
      (system: f system nixpkgs.legacyPackages.${system});

  mkCommon = system: pkgs:
    let
      sources = import ./common/sources.nix { inherit system; };
    in {

      inherit sources;
      xtensaRust = pkgs.callPackage ./common/packages/xtensa-rust.nix { inherit sources; };
      xtensaGcc = pkgs.callPackage ./common/packages/xtensa-gcc.nix { inherit sources; };

    };

  mkPackages = system: pkgs:
    let
      common = mkCommon system pkgs;
      espIdf = import ./std/esp-idf.nix { inherit pkgs system nixpkgs-esp-dev; };
    in {

      inherit (common) xtensaRust xtensaGcc;
      inherit espIdf;
      default = common.xtensaRust;

    };

  mkDevShells = system: pkgs:
    let
      common = mkCommon system pkgs;
      noStd = import ./no_std/devshell.nix {
        inherit pkgs;
        inherit (common) xtensaRust xtensaGcc;
      };
    in {

      default = noStd;
      no_std = noStd;
      std = import ./std/devshell.nix {
        inherit pkgs system nixpkgs-esp-dev;
        inherit (common) xtensaRust;
      };

    };
in {

  packages = forAllSystems mkPackages;
  devShells = forAllSystems mkDevShells;
  nixosModules.default = import ./common/nixos-module.nix;

}

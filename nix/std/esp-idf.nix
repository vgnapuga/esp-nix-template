{ pkgs, system, nixpkgs-esp-dev }:
let
  espPkgs = import pkgs.path {
    inherit system;
    config = pkgs.config // {
      permittedInsecurePackages =
        (pkgs.config.permittedInsecurePackages or [])
        ++ [ "python3.13-ecdsa-0.19.2" ];
    };
    overlays = [
      (final: prev: { python310 = prev.python311; })
      (import "${nixpkgs-esp-dev}/overlay.nix")
    ];
  };
in espPkgs.esp-idf-xtensa.override {

  toolsToInclude = [
    "xtensa-esp-elf"
    "esp32ulp-elf"
    "openocd-esp32"
    "esp-rom-elfs"
  ];

}

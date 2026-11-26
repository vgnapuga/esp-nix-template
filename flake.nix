{
  description = "ESP32-S3 Rust: no_std (esp-hal) and std (ESP-IDF)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-esp-dev = {
      url = "github:mirrexagon/nixpkgs-esp-dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-esp-dev }:
    import ./nix { inherit nixpkgs nixpkgs-esp-dev; };
}

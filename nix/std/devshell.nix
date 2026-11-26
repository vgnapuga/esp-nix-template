{ pkgs, system, nixpkgs-esp-dev, xtensaRust }:
let
  espIdf = import ./esp-idf.nix { inherit pkgs system nixpkgs-esp-dev; };
in pkgs.mkShell {

  packages = with pkgs; [
    xtensaRust
    espIdf
    ldproxy
    espflash
    probe-rs-tools
    cargo-generate
    rust-analyzer
    pkg-config
    openssl
    libusb1
    llvmPackages.libclang
    git
    just
  ];

  MCU = "esp32s3";
  ESP_IDF_VERSION = espIdf.version;
  ESP_IDF_TOOLS_INSTALL_DIR = "fromenv";

  LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
  RUST_SRC_PATH = "${xtensaRust}/lib/rustlib/src/rust/library";
  CARGO_TARGET_XTENSA_ESP32S3_ESPIDF_LINKER = "${pkgs.ldproxy}/bin/ldproxy";
  SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";

  shellHook = ''
    echo "ESP-IDF std toolchain: $ESP_IDF_VERSION"
    rustc --version || true
    xtensa-esp32s3-elf-gcc --version | head -n1 || true
    idf.py --version || true

    esp-new-std() {
      local name="''${1:-firmware-std}"
      cargo generate --git https://github.com/esp-rs/esp-idf-template cargo \
        --name "$name" \
        --define mcu=esp32s3 \
        --define advanced=false
      rm -f "$name/rust-toolchain.toml"
      sed -i 's/ESP_IDF_TOOLS_INSTALL_DIR = "workspace"/ESP_IDF_TOOLS_INSTALL_DIR = "fromenv"/' "$name/.cargo/config.toml"
      echo "Проект '$name' создан."
    }
  '';

}

{ pkgs, xtensaRust, xtensaGcc }: pkgs.mkShell {

  packages = with pkgs; [
    xtensaRust
    xtensaGcc
    espflash
    probe-rs-tools
    esp-generate
    rust-analyzer
    pkg-config
    openssl
    libusb1
    llvmPackages.libclang
    git
    just
  ];

  LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
  RUST_SRC_PATH = "${xtensaRust}/lib/rustlib/src/rust/library";
  CARGO_TARGET_XTENSA_ESP32S3_NONE_ELF_LINKER =
    "${xtensaGcc}/bin/xtensa-esp32s3-elf-gcc";
  SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";

  shellHook = ''
    echo "ESP32-S3 no_std (esp-hal):"
    rustc --version || true
    xtensa-esp32s3-elf-gcc --version | head -n1 || true

    esp-new() {
      local name="''${1:-firmware}"
      shift || true
      esp-generate --headless --chip esp32s3 "$@" "$name"
      rm -f "$name/rust-toolchain.toml"
      echo "Проект '$name' создан; rust-toolchain.toml удалён."
    }
  '';

}

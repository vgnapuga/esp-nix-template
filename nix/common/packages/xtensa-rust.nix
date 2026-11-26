{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  glibc,
  zlib,
  sources
}: stdenv.mkDerivation {

  pname = "xtensa-rust";
  version = sources.espRustVersion;

  src = fetchurl {
    url = "https://github.com/esp-rs/rust-build/releases/download/v${sources.espRustVersion}/rust-${sources.espRustVersion}-${sources.rust.triple}.tar.xz";
    hash = sources.rust.hash;
  };

  srcSrc = fetchurl {
    url = "https://github.com/esp-rs/rust-build/releases/download/v${sources.espRustVersion}/rust-src-${sources.espRustVersion}.tar.xz";
    hash = sources.espRustSrcHash;
  };

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ glibc stdenv.cc.cc.lib zlib ];

  dontStrip = true;
  dontPatchELF = true;

  unpackPhase = ''
    runHook preUnpack
    tar -xJf "$src"
    mkdir -p rust-src
    tar -xJf "$srcSrc" -C rust-src
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    bash rust-nightly-${sources.rust.triple}/install.sh \
      --destdir=$out \
      --prefix= \
      --without=rust-docs-json-preview,rust-docs \
      --disable-ldconfig
    bash rust-src/rust-src-nightly/install.sh \
      --destdir=$out \
      --prefix= \
      --disable-ldconfig
    runHook postInstall
  '';

}

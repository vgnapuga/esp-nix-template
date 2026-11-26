{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  glibc,
  zlib,
  ncurses5,
  gmp,
  mpfr,
  libmpc,
  isl,
  python3,
  libxml2,
  sources
}: stdenv.mkDerivation {

  pname = "xtensa-esp-elf-gcc";
  version = sources.espGccVersion;

  src = fetchurl {
    url = "https://github.com/espressif/crosstool-NG/releases/download/esp-${sources.espGccVersion}/xtensa-esp-elf-${sources.espGccVersion}-${sources.gcc.triple}.tar.xz";
    hash = sources.gcc.hash;
  };

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [
    glibc
    stdenv.cc.cc.lib
    zlib
    ncurses5
    gmp
    mpfr
    libmpc
    isl
    python3
    libxml2
  ];

  autoPatchelfIgnoreMissingDeps = [
    "libpython3.13.so.1.0"
    "libpython3.12.so.1.0"
    "libpython3.11.so.1.0"
    "libpython3.10.so.1.0"
    "libpython3.9.so.1.0"
  ];

  dontStrip = true;
  dontPatchELF = true;

  unpackPhase = ''
    runHook preUnpack
    tar -xJf "$src"
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r xtensa-esp-elf/. $out/
    runHook postInstall
  '';

}

{
  lib,
  makeRustPlatform,
  stdenvAdapters,
  llvm,
  rust-bin,
  ...
}: let
  toml = (lib.importTOML ../Cargo.toml).package;
  pname = toml.name;
  inherit (toml) version;
  rustPlatform = makeRustPlatform {
    cargo = rust-bin.selectLatestNightlyWith (toolchain: toolchain.default);
    rustc = rust-bin.selectLatestNightlyWith (toolchain: toolchain.default);
  };
in
  rustPlatform.buildRustPackage.override {stdenv = stdenvAdapters.useMoldLinker llvm.stdenv;} {
    RUSTFLAGS = "-C link-arg=-fuse-ld=mold";

    inherit pname version;

    src = builtins.path {
      name = "${pname}-${version}";
      path = lib.sources.cleanSource ../.;
    };

    cargoLock.lockFile = ../Cargo.lock;
    doCheck = false;
    meta = {
      description = "Wallpaper stuff";
      homepage = "https://github.com/dragyx/satpaper";
      license = lib.licenses.asl20;
      maintainers = with lib.maintainers; [Bloxx12 Dragyx];
      mainProgram = "satpaper";
    };
  }

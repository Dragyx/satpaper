{
  callPackage,
  rust-analyzer,
  rustfmt,
  clippy,
  cargo,
  rust-bin,
}: let
  mainPackage = callPackage ./package.nix {inherit rust-bin;};
in
  mainPackage.overrideAttrs (mp: {
    nativeBuildInputs =
      [
        # Additional rust tooling
        rust-analyzer
        rustfmt
        clippy
        cargo
      ]
      ++ (mp.nativeBuildInputs or []);
  })

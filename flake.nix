{
  description = "A fork of satpaper, actually sane.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    rust-overlay,
  }: let
    systems = ["x86_64-linux" "aarch64-linux"];
    forEachSystem = nixpkgs.lib.genAttrs systems;
    pkgsForEach = nixpkgs.legacyPackages;
  in {
    packages = forEachSystem (system: rec {
      rust-bin =
        (pkgsForEach.${system}.extend rust-overlay.overlays.default).rust-bin;
      default = pkgsForEach.${system}.callPackage ./nix/package.nix {inherit rust-bin;};
    });
    devShells = forEachSystem (system: rec {
      rust-bin =
        (pkgsForEach.${system}.extend rust-overlay.overlays.default).rust-bin;
      default = pkgsForEach.${system}.callPackage ./nix/shell.nix {inherit rust-bin;};
    });
  };
}

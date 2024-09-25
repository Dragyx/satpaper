{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    naersk.url = "github:nix-community/naersk";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, naersk, rust-overlay }: 
  let 
    system = "x86_64-linux";
    pkgs = (import nixpkgs) {
      inherit system;
      overlays = [ (import rust-overlay) ];
    };
    naersk' = pkgs.callPackage naersk {};
  in rec {
    packages.${system}.satpaper = naersk'.buildPackage {
      src = ./.;
      
    };
    defaultPackage.${system} = packages.${system}.satpaper;
    devShell.${system} = pkgs.mkShell {
      nativeBuildInputs = with pkgs; [ rust-bin.nightly.latest.default ];
    };

  };
}

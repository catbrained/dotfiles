{
  description = "A minimal Rust template that can be dropped into existing repos or empty directories.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
        rustToolchain = pkgs.pkgsBuildHost.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;
        # rustToolchain = pkgs.pkgsBuildHost.rust-bin.stable.latest.default.override {
        #   extensions = [
        #     "rust-src"
        #   ];
        # }
      in
      {
        devShells = {
          default = pkgs.mkShell {
            nativeBuildInputs = [
              rustToolchain
            ];

            packages = [
              pkgs.rust-analyzer
            ];
          };
        };
      });
}

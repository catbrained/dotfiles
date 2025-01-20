{
  description = "A simple Typescript template.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in
      {
        devShells = {
          default = pkgs.mkShell {
            nativeBuildInputs = [
            ];

            packages = [
              pkgs.yarn
              pkgs.nodePackages_latest.prettier
            ];
          };
        };
      });
}

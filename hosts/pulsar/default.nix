{ nixpkgs, ... }:
nixpkgs.lib.nixosSystem {
  modules = [
    ./configuration.nix
  ];
}

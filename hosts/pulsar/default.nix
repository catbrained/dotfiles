{ nixpkgs, disko, home-manager, ... }:
nixpkgs.lib.nixosSystem {
  modules = [
    disko.nixosModules.disko
    ./configuration.nix
    ./hardware-configuration.nix
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.linda = import ../../home/pulsar.nix;
    }
  ];
}

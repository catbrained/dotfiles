{ nixpkgs, disko, home-manager, ... }:
nixpkgs.lib.nixosSystem {
  modules = [
    {
      nixpkgs.config.packageOverrides = pkgs:
        {
          linux-manual = pkgs.linux-manual.overrideAttrs {
            env.srctree = ".";
          };
        };
    }
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

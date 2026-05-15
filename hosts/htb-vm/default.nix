{ nixpkgs, home-manager, ... }:
nixpkgs.lib.nixosSystem {
  modules = [
    ./configuration.nix
    ./hardware-configuration.nix
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.linda = import ../../home/htb-vm.nix;
    }
  ];
}

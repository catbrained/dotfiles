# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/ea548103-6ff2-4c8b-a895-37e7d524f0a1";
      fsType = "btrfs";
      options = [ "noatime" "nodiscard" "compress=zstd" "subvol=root" ];
    };

  fileSystems."/home" =
    {
      device = "/dev/disk/by-uuid/ea548103-6ff2-4c8b-a895-37e7d524f0a1";
      fsType = "btrfs";
      options = [ "noatime" "nodiscard" "compress=zstd" "subvol=home" ];
    };

  boot.initrd.luks.devices."cryptnixos".device = "/dev/disk/by-uuid/a2f7aaac-2bf7-4ad7-84b2-8409fc11af30";

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/FF70-C774";
      fsType = "vfat";
      options = [ "noatime" "nodev" "nosuid" "noexec" "uid=0" "gid=0" "fmask=0077" "dmask=0077" ];
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  # This is currently already set via `(modulesPath + "/installer/scan/not-detected.nix")` in
  # the import up top, but let's set this here explicitly, just to be sure.
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

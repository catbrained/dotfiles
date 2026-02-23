{
  description = "Linda's NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Tool for updating microcode on AMD consumer CPUs
    ucodenix.url = "github:e-tho/ucodenix/e6bba9fbe258049db05e62809ce78adc875e4977";

    # Secrets management
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, sops-nix, ucodenix, ... }:
    {
      nixosConfigurations = {
        quasar = import ./hosts/quasar { inherit nixpkgs home-manager sops-nix ucodenix; };
        pulsar = import ./hosts/pulsar { inherit nixpkgs; };
      };
    };
}

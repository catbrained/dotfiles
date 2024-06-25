{
  description = "Linda's NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      # List of packages with unfree licenses that are allowed
      allowedUnfree = [
        "vital"
        "steam"
        "steam-original"
        "steam-run"
        "discord"
      ];
    in
    {
      nixosConfigurations = {
        "quasar" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            {
              nixpkgs.config.packageOverrides = pkgs: {
                catppuccin-plymouth = pkgs.catppuccin-plymouth.override {
                  variant = "mocha";
                };
              };
            }
            {
              nixpkgs.config.allowUnfreePredicate = pkg:
                builtins.elem (nixpkgs.lib.getName pkg) allowedUnfree;
            }
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.linda = import ./home.nix;
            }
          ];
        };
      };
    };
}

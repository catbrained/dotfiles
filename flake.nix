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
        "discord"
      ];
    in
    {
      nixosConfigurations = {
        "quasar" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
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
            {
              # Make commands like `nix run nixpkgs#hello` use the same nixpkgs as this flake
              # See: https://nixos-and-flakes.thiscute.world/best-practices/nix-path-and-flake-registry#custom-nix-path-and-flake-registry-1
              nix.registry.nixpkgs.flake = nixpkgs;

              # Make `nix repl '<nixpkgs>'` use the same nixpkgs as this flake
              # See: https://nixos-and-flakes.thiscute.world/best-practices/nix-path-and-flake-registry#custom-nix-path-and-flake-registry-1
              environment.etc."nix/inputs/nixpkgs".source = "${nixpkgs}";
              # See: https://github.com/NixOS/nix/issues/9574
              nix.settings.nix-path = nixpkgs.lib.mkForce "nixpkgs=/etc/nix/inputs/nixpkgs";

            }
          ];
        };
      };
    };
}

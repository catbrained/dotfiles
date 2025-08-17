{
  description = "Linda's NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Tool for updating microcode on AMD consumer CPUs
    ucodenix.url = "github:e-tho/ucodenix/56c73f68361ae713be920bd221592c381f82fa23";
  };

  outputs = { self, nixpkgs, home-manager, ucodenix, ... }@inputs:
    let
      # List of packages with unfree licenses that are allowed
      allowedUnfree = [
        "corefonts"
        "vista-fonts"
        "vital"
        "steam"
        "steam-original"
        "steam-run"
        "steam-unwrapped"
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
                catppuccin-sddm = pkgs.catppuccin-sddm.override {
                  flavor = "mocha";
                };
                catppuccin-plymouth = pkgs.catppuccin-plymouth.override {
                  variant = "mocha";
                };
              };
            }
            {
              nixpkgs.config.allowUnfreePredicate = pkg:
                builtins.elem (nixpkgs.lib.getName pkg) allowedUnfree;
            }
            ucodenix.nixosModules.default
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.linda = import ./home.nix;
            }
          ];
        };

        # Build it with `nix run nixpkgs#nixos-generators -- --format iso --flake .#customIso -o result`
        customIso = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/customIso/configuration.nix
          ];
        };
      };

      templates = {
        rustMinimal = {
          path = ./templates/rust-minimal;
          description = "A minimal Rust template that can be dropped into existing repos or empty directories.";
        };
        typescript = {
          path = ./templates/typescript;
          description = "A simple Typescript template.";
        };
      };
    };
}

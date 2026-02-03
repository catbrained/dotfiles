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
        "teamspeak6-client"
      ];
    in
    {
      nixosConfigurations = {
        "quasar" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            {
              nixpkgs.config.packageOverrides = pkgs: {
                google-fonts = pkgs.google-fonts.overrideAttrs (finalAttrs: previousAttrs: {
                  # "Sour Gummy" isn't in the version that's in nixpkgs yet.
                  src = pkgs.fetchFromGitHub {
                    owner = "google";
                    repo = "fonts";
                    rev = "5fa1b4a6c5feaaab0c0e09a568f3d332bcab355b";
                    hash = "sha256-SDlokzULEzbZI/vEap9AukTlgJRDhzg1Qw3XjpwDSek=";
                  };
                });
                # catppuccin-sddm = pkgs.catppuccin-sddm.override {
                #   flavor = "mocha";
                # };
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
              home-manager.users.linda = import ./home;
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

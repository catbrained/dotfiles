{ pkgs, ... }:
{
  imports = [
    ./disk-config.nix
    ./ssh.nix
    ./nginx.nix
    ./acme.nix
    ./website.nix
  ];

  config = {
    nixpkgs.hostPlatform = "aarch64-linux";
    system.stateVersion = "25.11";

    nix = {
      package = pkgs.lixPackageSets.latest.lix;
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        auto-optimise-store = true;
      };
      channel.enable = false;
      gc = {
        automatic = true;
        dates = "weekly";
        randomizedDelaySec = "30min";
        options = "--delete-older-than 7d";
      };
    };

    boot = {
      tmp.useTmpfs = true;
      kernelPackages = pkgs.linuxPackages_latest;
      loader.systemd-boot = {
        enable = true;
        editor = false;
        configurationLimit = 10;
      };
      loader.efi.canTouchEfiVariables = true;
      initrd.systemd = {
        enable = true;
      };
    };

    networking.hostName = "pulsar";
    networking.useNetworkd = true;
    systemd.network = {
      enable = true;
      links = {
        "00-wired" = {
          matchConfig = {
            # This is the interface I want to configure
            MACAddress = "86:a6:4d:d8:b8:9d";
          };
          linkConfig = {
            # This is the name I want the interface to have
            Name = "wired0";
          };
        };
      };
      networks = {
        "00-wired" = {
          matchConfig = {
            # The name of the interface to match against
            Name = "wired0";
          };
          address = [
            "2a03:4000:60:b9c::/64"
            "89.58.12.21/22"
          ];
          gateway = [
            "fe80::1"
            "89.58.12.1"
          ];
          networkConfig = {
            IPv6PrivacyExtensions = true;
          };
        };
      };
    };
    services.resolved.enable = true;

    users.mutableUsers = false;
    users.users.linda = {
      isNormalUser = true;
      uid = 1000;
      group = "linda";
      extraGroups = [
        "wheel"
      ];
      hashedPassword = "$y$j9T$0lbzPlCzrriScQwT0YVK6.$q6mHKS0M/z82hVt/pJQOQeb1gK6DV97xp5gUsHcwi.D";
      shell = pkgs.fish;
      ignoreShellProgramCheck = true;
    };
    users.groups = {
      linda = {
        gid = 1000;
      };
    };

    environment.systemPackages = [
      pkgs.vim
      pkgs.wget
      pkgs.curl
      pkgs.file
      pkgs.git
      pkgs.helix # Editor
      pkgs.nil # LSP for Nix
      pkgs.nixpkgs-fmt # Formatter for Nix
    ];
    # Set default editor to helix
    environment.variables.EDITOR = "hx";

    # Set your time zone.
    time.timeZone = "Europe/Berlin";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_TIME = "en_DK.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
    };
    console = {
      # Let the kernel pick a suitable font depending on resolution
      font = null;
      useXkbConfig = true; # use xkbOptions in tty.
    };

    # Configure keymap in X11
    services.xserver = {
      xkb = {
        layout = "de";
        variant = "nodeadkeys";
        # Make caps lock an additional esc, both shifts together enable caps lock
        options = "caps:escape,shift:both_capslock";
      };
    };
  };
}

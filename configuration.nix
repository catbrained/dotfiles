# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix = {
    settings = {
      # Enable flakes and the new nix commands
      experimental-features = [ "nix-command" "flakes" ];
      # Save disk space by using hardlinks for identical files in the store
      auto-optimise-store = true;
    };
    # I'm using flakes, so I don't need this, right?
    channel.enable = false;
    # Garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      randomizedDelaySec = "30min";
      options = "--delete-older-than 1w";
    };
  };

  boot = {
    # Delete all files in /tmp during boot
    # tmp.cleanOnBoot = true;
    # Mount a tmpfs on /tmp
    # Warning: Large Nix builds may fail if the tmpfs is too small!
    tmp.useTmpfs = true;
    kernelPackages = pkgs.linuxPackages_latest;
    # Boot splash screen
    plymouth = {
      enable = true;
      themePackages = [ (pkgs.catppuccin-plymouth.override { variant = "mocha"; }) ];
      theme = "catppuccin-mocha";
    };
    loader.systemd-boot = {
      # Use the systemd-boot EFI boot loader.
      enable = true;
      # Do not allow editing the kernel command-line before boot
      editor = false;
      # Limit number of NixOS generations available at boot to prevent running out of space
      configurationLimit = 10;
    };
    loader.efi.canTouchEfiVariables = true;
    initrd.systemd = {
      enable = true;
    };
  };

  networking.hostName = "quasar"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Simple networking configuration based on a succinct blog post and, of course, the Arch Wiki.
  # See: https://insanity.industries/post/simple-networking/
  networking.useNetworkd = true;
  systemd.network = {
    enable = true;
    links = {
      "00-wifi" = {
        matchConfig = {
          # This is the interface I want to configure
          MACAddress = "14:5a:fc:16:8b:cf";
        };
        linkConfig = {
          # This is the name I want the interface to have
          Name = "wifi0";
        };
      };

    };
  };
  networking.wireless.iwd = {
    # Use iwd as wireless backend
    enable = true;
    settings = {
      General = {
        # Allows us to set the interface name ourselves.
        # See the above section `systemd.network.links` for setting the name.
        UseDefaultInterface = true;
        # Enable builtin DHCP client
        EnableNetworkConfiguration = true;
        # Randomize MAC address every time iwd starts or the hardware is initially detected.
        AddressRandomization = "once";
      };
    };
  };
  services.resolved.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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

  fonts = {
    enableDefaultPackages = true;
    packages = [
      pkgs.iosevka
    ];
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  # The PulseAudio server uses this to acquire realtime priority
  security.rtkit.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.linda = {
    isNormalUser = true;
    uid = 1000;
    group = "linda";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
    # fish is enabled via home-manager
    ignoreShellProgramCheck = true;
    packages = [ ];
  };
  users.groups.linda = {
    gid = 1000;
  };

  security.loginDefs.settings = {
    # Login is not allowed if we can't cd to the home directory
    DEFAULT_HOME = "no";
  };

  # PAM must be configured to enable swaylock to perform authentication.
  # The home-manager package will not be able to unlock the session without this.
  security.pam.services.swaylock = { };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = [
    pkgs.vim
    pkgs.wget
    pkgs.curl
    pkgs.file
    pkgs.helix # Editor
    pkgs.git
    pkgs.nil # LSP for Nix
    pkgs.nixpkgs-fmt # Formatter for Nix
  ];

  # Set default editor to helix
  environment.variables.EDITOR = "hx";
  environment.sessionVariables = {
    # Hint for Electron apps to use Wayland
    NIXOS_OZONE_WL = "1";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.hyprland = {
    enable = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  services.xserver.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    autoNumlock = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}

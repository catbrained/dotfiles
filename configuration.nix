# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, inputs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix = {
    package = pkgs.lixPackageSets.latest.lix;
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
      options = "--delete-older-than 7d";
    };
  };

  # AMD microcode updates
  services.ucodenix = {
    enable = true;
    cpuModelId = "00A50F00";
  };

  # services.udev.extraRules doesn't work with udev rules that use uaccess
  # See: https://github.com/NixOS/nixpkgs/issues/308681
  services.udev.packages = [
    (pkgs.writeTextFile
      {
        name = "microbit-udev-rules";
        # See: https://wiki.archlinux.org/title/Udev#Allowing_regular_users_to_use_devices
        text = ''
          SUBSYSTEMS=="usb", ATTRS{idVendor}=="0d28", ATTRS{idProduct}=="0204", MODE="0660", TAG+="uaccess"
        '';
        destination = "/etc/udev/rules.d/70-microbit.rules";
      }
    )
  ];

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
      themePackages = [ pkgs.catppuccin-plymouth ];
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
    extraModulePackages = [
      config.boot.kernelPackages.v4l2loopback
    ];
    kernelModules = [
      "v4l2loopback"
    ];
    extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    '';
  };

  security.polkit.enable = true;

  virtualisation.podman.enable = true;

  networking.hostName = "quasar"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Simple networking configuration based on a succinct blog post and, of course, the Arch Wiki.
  # See: https://insanity.industries/post/simple-networking/
  # See: https://wiki.archlinux.org/title/Systemd-networkd#Wired_and_wireless_adapters_on_the_same_machine
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
      "00-wired" = {
        matchConfig = {
          # This is the interface I want to configure
          MACAddress = "60:7d:09:6d:c4:40";
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
        networkConfig = {
          DHCP = true;
          IPv6PrivacyExtensions = true;
        };
        dhcpV4Config = {
          RouteMetric = 100;
        };
        ipv6AcceptRAConfig = {
          RouteMetric = 100;
        };
      };
    };
  };
  networking.wireless.iwd = {
    # Use iwd as wireless backend
    enable = true;
    settings = {
      General = {
        # Enable builtin DHCP client
        EnableNetworkConfiguration = true;
        # Randomize MAC address every time iwd starts or the hardware is initially detected.
        AddressRandomization = "once";
      };
      DriverQuirks = {
        # Allows us to set the interface name ourselves.
        # See the above section `systemd.network.links` for setting the name.
        UseDefaultInterface = true;
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
      pkgs.vegur
      pkgs.noto-fonts-cjk-sans
      pkgs.noto-fonts-cjk-serif
      pkgs.ipaexfont
      (pkgs.google-fonts.overrideAttrs (finalAttrs: previousAttrs: {
        # "Sour Gummy" isn't in the version that's in nixpkgs yet.
        src = pkgs.fetchFromGitHub {
          owner = "google";
          repo = "fonts";
          rev = "5fa1b4a6c5feaaab0c0e09a568f3d332bcab355b";
          hash = "sha256-SDlokzULEzbZI/vEap9AukTlgJRDhzg1Qw3XjpwDSek=";
        };
        fonts = [
          "SourGummy"
        ];
      }))
    ];
  };

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [
      pkgs.brlaser
      pkgs.hplip
    ];
  };
  # Enable SANE to enable scanning
  hardware.sane = {
    enable = true;
  };
  services.ipp-usb.enable = true;

  services.udisks2.enable = true;

  hardware.bluetooth = {
    enable = true;
  };

  # Enable sound.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    jack.enable = true;
    alsa.enable = true;
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
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "wireshark" # Let me capture packets
    ];
    shell = pkgs.fish;
    # fish is enabled via home-manager
    ignoreShellProgramCheck = true;
    packages = [ ];
  };
  users.groups = {
    linda = {
      gid = 1000;
    };
  };

  security.loginDefs.settings = {
    # Login is not allowed if we can't cd to the home directory
    DEFAULT_HOME = "no";
  };

  # PAM must be configured to enable swaylock to perform authentication.
  # The home-manager package will not be able to unlock the session without this.
  security.pam.services.swaylock = { };

  documentation = {
    man = {
      generateCaches = false; # slow as heck, so keep this off for now
    };
    dev = {
      enable = true;
    };
    nixos = {
      includeAllModules = true;
    };
  };

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
    pkgs.podman-compose
    pkgs.catppuccin-sddm
    pkgs.man-pages
    pkgs.man-pages-posix
    pkgs.linux-manual
    pkgs.hplip
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

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  programs.hyprland = {
    enable = true;
  };

  programs.steam = {
    enable = true;
  };

  programs.gamescope = {
    enable = true;
    capSysNice = false;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  services.xserver.enable = true;
  services.displayManager.sddm = {
    enable = true;
    package = pkgs.kdePackages.sddm;
    wayland = {
      enable = true;
      compositor = "kwin";
    };
    autoNumlock = true;
    theme = "${pkgs.catppuccin-sddm}/share/sddm/themes/catppuccin-mocha-mauve";
  };
  services.displayManager.defaultSession = "hyprland";

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
  system.stateVersion = "25.05"; # Did you read the comment?

}

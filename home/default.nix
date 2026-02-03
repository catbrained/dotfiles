{ config, pkgs, lib, ... }:
# let
#   customCDDAMods = self: super: lib.recursiveUpdate super {
#     soundpack.CCsounds = pkgs.cataclysmDDA.buildSoundPack {
#       modName = "CCsounds";
#       version = "2024-10-27";
#       src = pkgs.fetchFromGitHub {
#         owner = "Fris0uman";
#         repo = "CDDA-Soundpacks";
#         rev = "2024-10-27";
#         hash = "sha256-CWv2xD06+Z3uTwf4IcZSHLXP1Fm0ozvSRKih70VOcPw=";
#       };
#       modRoot = "sound/CC-Sounds";
#     };
#   };
# in
{
  imports = [
    ./helix.nix
    ./bat.nix
    ./fish.nix
    ./kitty.nix
    ./git.nix
    ./direnv.nix
    ./bash.nix
    ./starship.nix
    ./eza.nix
    ./fd.nix
    ./ripgrep.nix
    ./fzf.nix
    ./swaylock.nix
    ./hyprland.nix
    ./obs-studio.nix
    ./dunst.nix
  ];

  home.username = "linda";
  home.homeDirectory = "/home/linda";
  home.packages = [
    pkgs.tlrc # tldr client
    pkgs.zip
    pkgs.unzip
    pkgs.libnotify
    pkgs.jq # json utility
    pkgs.socat # socket communication utility
    pkgs.wl-clipboard
    pkgs.brightnessctl
    pkgs.playerctl
    pkgs.vesktop
    pkgs.revolt-desktop
    pkgs.element-desktop
    pkgs.teamspeak6-client
    pkgs.inkscape
    pkgs.gimp
    pkgs.krita
    pkgs.darktable
    pkgs.godot_4
    pkgs.evince
    pkgs.calibre
    # pkgs.img2pdf
    pkgs.libreoffice-fresh
    pkgs.slurp # select a region in a wayland compositor
    pkgs.grim # grab an image in a wayland compositor
    pkgs.satty # screenshot annotation tool
    pkgs.openttd
    # (pkgs.cataclysm-dda.withMods
    #   (mods: with mods.extend customCDDAMods; [
    #     soundpack.CCsounds
    #   ]))
    pkgs.swww # Wallpaper
    pkgs.audacity
    pkgs.ardour # DAW
    pkgs.vital # wavetable synth
    pkgs.geonkick # drums
    pkgs.helvum # pipewire patchbay
    pkgs.lsp-plugins # lots of nice audio plugins
    pkgs.guitarix # Guitar plugins
    pkgs.intiface-central
    pkgs.luanti
    (pkgs.callPackage ../pkgs/ksp.nix { })
    (pkgs.callPackage ../pkgs/new-project.nix { })
    pkgs.ckan
    pkgs.jellyfin-media-player
    pkgs.protontricks
    pkgs.wineWowPackages.waylandFull
    pkgs.lutris
    pkgs.winetricks
    pkgs.ausweisapp
  ];

  # For some reason Home Manager fails to load env vars correctly.
  # This means things like $SSH_AUTH_SOCK won't be available.
  # This block is a workaround for this issue.
  # See: https://github.com/nix-community/home-manager/issues/3263#issuecomment-1505801395
  home.file.".profile".text = ''
    . "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh"
  '';

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Grey-Darkest";
    };
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
  };

  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      "text/html" = [ "firefox.desktop" ];
    };
  };

  # HM managed scripts

  # screenshots
  home.file."bin/screenshot.fish" = {
    enable = true;
    executable = true;
    recursive = true;
    text = ''
      #!/usr/bin/env fish

      grim -g "$(slurp -d -o -c '#ff0000ff' && sleep 0.4)" - | satty --filename - --copy-command wl-copy --output-filename ~/pictures/screenshots/screenshot-$(date '+%Y%m%d-%H:%M:%S').png
    '';
  };

  # wallpaper
  home.file."bin/wallpapers.fish" = {
    enable = true;
    executable = true;
    recursive = true;
    text = ''
      #!/usr/bin/env fish

      set -gx SWWW_TRANSITION any
      set -gx SWWW_TRANSITION_STEP 20
      set -gx SWWW_TRANSITION_DURATION 3
      set -gx SWWW_TRANSITION_FPS 60
      set interval 180 # in seconds
      set wallpaper_path ~/pictures/wallpapers/active
      set -U wallpaper_change_paused 0

      while true
        set images (shuf -e $wallpaper_path/*)
        for img in $images
          if test $wallpaper_change_paused = 0
            swww img $img
          end
            sleep $interval
        end
      end
    '';
  };

  services.playerctld = {
    enable = true;
  };

  programs.firefox = {
    enable = true;
  };

  # image viewer
  programs.imv = {
    enable = true;
  };

  programs.mpv = {
    enable = true;
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      forwardAgent = false;
      addKeysToAgent = "confirm 20m";
      compression = false;
      serverAliveInterval = 0;
      serverAliveCountMax = 3;
      hashKnownHosts = false;
      userKnownHostsFile = "~/.ssh/known_hosts";
      controlMaster = "no";
      controlPath = "~/.ssh/master-%r@%n:%p";
      controlPersist = "no";
    };
    extraConfig = ''
      PasswordAuthentication no
    '';
  };

  services.ssh-agent.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

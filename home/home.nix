{ config, pkgs, lib, ... }:
{
  imports = [
    ./audio.nix
    ./anki.nix
    ./helix.nix
    ./bat.nix
    ./fish.nix
    ./fcitx5.nix
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
    ./obs-studio.nix
    ./dunst.nix
    ./playerctl.nix
    ./firefox.nix
    ./imv.nix
    ./mpv.nix
    ./ssh.nix
  ];

  options = {
    localhost.enable = lib.mkEnableOption "Is this a machine that I use locally (e.g., laptop)?";
  };

  config =
    let
      packages.common = [
        pkgs.tlrc
        pkgs.age
        pkgs.ssh-to-age
      ];
      packages.localhost = [
        pkgs.zip
        pkgs.unzip
        pkgs.libnotify
        pkgs.jq # json utility
        pkgs.socat # socket communication utility
        pkgs.wl-clipboard
        pkgs.brightnessctl
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
        pkgs.libreoffice-fresh
        pkgs.factorio-space-age
        pkgs.openttd
        pkgs.intiface-central
        pkgs.luanti
        pkgs.ckan
        pkgs.jellyfin-media-player
        pkgs.protontricks
        pkgs.wineWow64Packages.waylandFull
        pkgs.lutris
        pkgs.protonplus
        pkgs.winetricks
        pkgs.ausweisapp
        pkgs.sops
      ];
    in
    {
      home.username = "linda";
      home.homeDirectory = "/home/linda";
      home.packages = packages.common
        ++ lib.optionals config.localhost.enable packages.localhost;

      # For some reason Home Manager fails to load env vars correctly.
      # This means things like $SSH_AUTH_SOCK won't be available.
      # This block is a workaround for this issue.
      # See: https://github.com/nix-community/home-manager/issues/3263#issuecomment-1505801395
      home.file.".profile".text = ''
        . "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh"
      '';

      xdg.mimeApps = {
        enable = true;

        defaultApplications = lib.mkIf config.localhost.enable {
          "text/html" = [ "firefox.desktop" ];
        };
      };

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
    };
}

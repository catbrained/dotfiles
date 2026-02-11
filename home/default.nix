{ config, pkgs, ... }:
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
    ./obs-studio.nix
    ./dunst.nix
    ./playerctl.nix
    ./firefox.nix
    ./imv.nix
    ./mpv.nix
    ./ssh.nix
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
    pkgs.slurp # select a region in a wayland compositor
    pkgs.grim # grab an image in a wayland compositor
    pkgs.satty # screenshot annotation tool
    pkgs.openttd
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
    pkgs.ckan
    pkgs.jellyfin-media-player
    pkgs.protontricks
    pkgs.wineWowPackages.waylandFull
    pkgs.lutris
    pkgs.winetricks
    pkgs.ausweisapp
    pkgs.age
    pkgs.ssh-to-age
    pkgs.sops
  ];

  # For some reason Home Manager fails to load env vars correctly.
  # This means things like $SSH_AUTH_SOCK won't be available.
  # This block is a workaround for this issue.
  # See: https://github.com/nix-community/home-manager/issues/3263#issuecomment-1505801395
  home.file.".profile".text = ''
    . "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh"
  '';

  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
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
}

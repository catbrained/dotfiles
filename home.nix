{ config, pkgs, ... }:

{
  home.username = "linda";
  home.homeDirectory = "/home/linda";

  programs.git = {
    enable = true;
    userEmail = "linda@catbrained.dev";
    userName = "Linda Siemons";
    extraConfig = {
      # XXX: The HM module does not yet support defaultBranch
      init.defaultBranch = "main";
      # XXX: The HM module does not yet support ssh signing
      commit.gpgSign = true;
      tag.gpgSign = true;
      user.signingKey = "~/.ssh/id_ed25519";
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "~/.config/git/allowed_signers";
    };
  };

  home.file.".config/git/allowed_signers".text = ''
    linda@catbrained.dev ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIAsoKQZS3EtdVd/wdw+m30ZAe5shaz1R+HENhwaVcHs linda@catbrained.dev
  '';

  # Terminal emulator
  programs.kitty = {
    enable = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = [
        # name,resolution@refreshrate,position,scale
        "eDP-1,2560x1600@120,0x0,1.25"
        ",preferred,auto,1" # hotplug random external monitor
      ];
      input = {
        kb_layout = "de";
        kb_variant = "nodeadkeys";
        # Make caps lock an additional esc,
        # both shifts together enable caps lock
        kb_options = "caps:escape,shift:both_capslock";
        numlock_by_default = true;
        touchpad = {
          natural_scroll = true;
          tap-and-drag = true;
          drag_lock = true;
        };
      };
      binds = {
        workspace_back_and_forth = true;
      };
      gestures = {
        workspace_swipe = true;
      };
      "$mod" = "SUPER";
      bind = [
        "$mod, Q, exec, kitty"
        "$mod, C, killactive"
        "$mod, M, exit"
        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, J, movefocus, d"
        "$mod, K, movefocus, u"
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        "$mod_SHIFT, H, movewindow, l"
        "$mod_SHIFT, L, movewindow, r"
        "$mod_SHIFT, J, movewindow, d"
        "$mod_SHIFT, K, movewindow, u"
        "$mod_SHIFT, 1, movetoworkspacesilent, 1"
        "$mod_SHIFT, 2, movetoworkspacesilent, 2"
        "$mod_SHIFT, 3, movetoworkspacesilent, 3"
        "$mod_SHIFT, 4, movetoworkspacesilent, 4"
        "$mod_SHIFT, 5, movetoworkspacesilent, 5"
        "$mod_SHIFT, 6, movetoworkspacesilent, 6"
        "$mod_SHIFT, 7, movetoworkspacesilent, 7"
        "$mod_SHIFT, 9, movetoworkspacesilent, 9"
        "$mod_SHIFT, 0, movetoworkspacesilent, 10"
        "$mod, F, fullscreen, 1" # maximize window (keep bar and gaps)
        "$mod_SHIFT, F, fullscreen, 0" # fullscreen
      ];
    };
  };

  programs.firefox = {
    enable = true;
  };

  programs.ssh = {
    enable = true;
    forwardAgent = false;
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

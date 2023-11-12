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
      user.signingKey = "/home/linda/.ssh/id_ed25519.pub";
      gpg.format = "ssh";
    };
  };

  # Terminal emulator
  programs.kitty = {
    enable = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      input = {
        kb_layout = "de";
        kb_variant = "nodeadkeys";
        # Make caps lock an additional esc,
        # both shifts together enable caps lock
        kb_options = "caps:escape,shift:both_capslock";
        numlock_by_default = true;
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

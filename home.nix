{ config, pkgs, ... }:

{
  home.username = "linda";
  home.homeDirectory = "/home/linda";
  home.packages = [
    pkgs.libnotify
    pkgs.jq # json utility
    pkgs.socat # socket communication utility
    pkgs.wl-clipboard
    pkgs.brightnessctl
    pkgs.playerctl
    pkgs.discord
    pkgs.element-desktop
    pkgs.inkscape
    pkgs.gimp
    pkgs.evince
    pkgs.libreoffice-fresh
  ];

  # For some reason Home Manager fails to load env vars correctly.
  # This means things like $SSH_AUTH_SOCK won't be available.
  # This block is a workaround for this issue.
  # See: https://github.com/nix-community/home-manager/issues/3263#issuecomment-1505801395
  home.file.".profile".text = ''
    . "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh"
  '';

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
      pull.rebase = true;
      # Diffing
      diff = {
        algorithm = "patience";
      };
    };
  };

  home.file.".config/git/allowed_signers".text = ''
    linda@catbrained.dev ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIAsoKQZS3EtdVd/wdw+m30ZAe5shaz1R+HENhwaVcHs linda@catbrained.dev
  '';

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.bash = {
    enable = true;
  };

  # The friendly interactive shell
  programs.fish = {
    enable = true;
    functions = {
      multicd = "echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)";
      last_history_item = "echo $history[1]";
    };
    shellAbbrs = {
      gs = "git status";
      gl = "git log";
      glp = "git log -p";
      glo = "git log --oneline";
      gd = "git diff";
      cat = "bat";
      "!!" = {
        position = "anywhere";
        function = "last_history_item";
      };
      dotdot = {
        regex = "^\\.\\.+$";
        function = "multicd";
      };
    };
  };

  # Shell prompt
  programs.starship = {
    enable = true;
    settings = { };
  };

  # Terminal emulator
  programs.kitty = {
    enable = true;
    theme = "Catppuccin-Mocha";
    settings = {
      font_family = "Iosevka";
      bold_font = "Iosevka Bold";
      italic_font = "Iosevka Italic";
      bold_italic_font = "Iosevka Bold Italic";
      font_size = 12;
    };
  };

  # A cat clone with wings
  programs.bat = {
    enable = true;
  };

  # Screen locker
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      daemonize = true;
      screenshots = true;
      clock = true;
      indicator = true;
      indicator-radius = 100;
      indicator-thickness = 7;
      ring-color = "bb00cc";
      key-hl-color = "880033";
      line-color = "00000000";
      inside-color = "00000088";
      separator-color = "00000000";
      fade-in = 0.5;
      show-failed-attempts = true;
      ignore-empty-password = true;
    };
  };

  # Helix editor
  programs.helix = {
    enable = true;
    defaultEditor = true;
    extraPackages = [
      pkgs.nil # LSP for Nix
      pkgs.nixpkgs-fmt # Formatter for Nix
      pkgs.nodePackages_latest.bash-language-server
      pkgs.vscode-langservers-extracted # Provides json, html, (s)css LSPs
      pkgs.marksman # Markdown LSP
      pkgs.nodePackages_latest.typescript-language-server # TS + JS
    ];
    languages = {
      language = [
        {
          name = "nix";
          auto-format = true;
          formatter = {
            command = "nixpkgs-fmt";
          };
        }
      ];
    };
    settings = {
      theme = "catppuccin_mocha";
      editor = {
        line-number = "relative";
        cursorline = true;
        color-modes = true;
        statusline = {
          left = [
            "mode"
            "spacer"
            "version-control"
            "spacer"
            "file-name"
            "read-only-indicator"
            "file-modification-indicator"
          ];
          center = [
            "spinner"
            "diagnostics"
            "workspace-diagnostics"
          ];
          right = [
            "selections"
            "primary-selection-length"
            "register"
            "position"
            "total-line-numbers"
            "file-type"
            "file-encoding"
          ];
        };
        lsp = {
          display-messages = true;
          display-inlay-hints = true;
        };
        indent-guides = {
          render = true;
          skip-levels = 1;
        };
        soft-wrap = {
          enable = true;
        };
      };
      keys.normal = {
        "A-<" = "shell_pipe_to";
        "+" = {
          g = {
            s = ":run-shell-command git status";
            l = ":run-shell-command git log --oneline";
          };
        };
        "space" = {
          u = ":update";
          q = ":quit-all";
        };
      };
    };
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
      general = {
        resize_on_border = true;
      };
      misc = {
        animate_manual_resizes = true;
        animate_mouse_windowdragging = true;
      };
      binds = {
        workspace_back_and_forth = true;
      };
      gestures = {
        workspace_swipe = true;
      };
      "$mod" = "SUPER";
      # Mouse binds
      bindm = [
        "$mod, mouse:272, movewindow"
      ];
      # Keybinds that can be held
      binde = [
        "$mod, Tab, cyclenext" # Focus next window in workspace
        "$mod_SHIFT, Tab, cyclenext, prev" # focus previous window in workspace
      ];
      # Keybinds that work while the screen is locked
      bindl = [
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ];
      # Keybinds that work while the screen is locked, and that allow press and hold
      bindel = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86MonBrightnessUp, exec, brightnessctl set +2%"
        ", XF86MonBrightnessDown, exec, brightnessctl set 2%-"
      ];
      bind = [
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioStop, exec, playerctl stop"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioNext, exec, playerctl next"
        "$mod, Return, exec, kitty --single-instance"
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
        "$mod, P, pin, active"
        "$mod_SHIFT, Space, togglefloating, active"
      ];
      windowrulev2 = [
        "float,class:^(firefox)$,title:^(Picture-in-Picture)$"
      ];
    };
    extraConfig = ''
      bind=$mod,escape,submap,powermenu
      submap=powermenu
      bind=,l,exec,swaylock --effect-scale 0.5 --effect-blur 7x5 --effect-scale 2
      bind=,l,submap,reset
      bind=,escape,submap,reset
      submap=reset
    '';
  };

  # Notification daemon
  services.dunst = {
    enable = true;
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
    forwardAgent = false;
    extraConfig = ''
      AddKeysToAgent confirm 20m
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
  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

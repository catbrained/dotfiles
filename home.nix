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
    pkgs.godot_4
    pkgs.evince
    pkgs.calibre
    # pkgs.img2pdf
    pkgs.libreoffice-fresh
    pkgs.slurp # select a region in a wayland compositor
    pkgs.grim # grab an image in a wayland compositor
    pkgs.satty # screenshot annotation tool
    pkgs.xivlauncher
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
    pkgs.kdePackages.xwaylandvideobridge
    pkgs.minetest
    (pkgs.callPackage ./pkgs/ksp.nix { })
    (pkgs.callPackage ./pkgs/new-project.nix { })
    pkgs.ckan
    # pkgs.jellyfin-media-player
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
      merge.conflictstyle = "diff3";
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
    interactiveShellInit = ''
      set -g fish_key_bindings fish_hybrid_key_bindings
      set -gx MANPAGER 'fish -c "col -bx | bat -l man -p"'
      set -gx MANROFFOPT '-c'
    '';
    functions = {
      fish_hybrid_key_bindings = {
        description = "Vi-style bindings that inherit emacs-style bindings in all modes";
        body = ''
          for mode in default insert visual
            fish_default_key_bindings -M $mode
          end
          fish_vi_key_bindings --no-erase
        '';
      };
      multicd = "echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)";
      last_history_item = "echo $history[1]";
      toggle_wallpaper_change = ''
        if test $wallpaper_change_paused = 0
          set -U wallpaper_change_paused 1
        else
          set -U wallpaper_change_paused 0
        end
      '';
      notify = ''
        set -l job (jobs -l -g)
        or begin; echo "There are no jobs" >&2; return 1; end

        function _notify_job_$job --on-job-exit $job --inherit-variable job
          echo -n \a # beep
          notify-send --transient "Job finished"
          functions -e _notify_job_$job
        end
      '';
    };
    shellAbbrs = {
      gs = "git status";
      gl = "git log";
      gl1 = "git log -1";
      glp = "git log -p";
      glo = "git log --oneline";
      gd = "git diff";
      ga = "git add";
      gap = "git add -p";
      gc = "git commit -sv";
      gr = "git rebase";
      gb = "git switch";
      "!!" = {
        position = "anywhere";
        function = "last_history_item";
      };
      dotdot = {
        regex = "^\\.\\.+$";
        function = "multicd";
      };
    } // (lib.optionalAttrs (config.programs.bat.enable) {
      cat = "bat";
    }) // (lib.optionalAttrs (config.programs.eza.enable) {
      l = "eza --hyperlink";
      ll = "eza --hyperlink -l -h --smart-group --git --git-repos";
      lll = "eza --hyperlink -l -h --smart-group -aa --git --git-repos";
    });
  };

  # Shell prompt
  programs.starship = {
    enable = true;
    settings = { };
  };

  # Terminal emulator
  programs.kitty = {
    enable = true;
    themeFile = "Catppuccin-Mocha";
    settings = {
      font_family = "Iosevka";
      bold_font = "Iosevka Bold";
      italic_font = "Iosevka Italic";
      bold_italic_font = "Iosevka Bold Italic";
      font_size = "13.5";
      enabled_layouts = "tall:bias=65;full_size=1;mirrored=true, fat:bias=65;full_size=1;mirrored=false, grid, splits:split:axis=horizontal, horizontal, vertical, stack";
      tab_bar_style = "powerline";
      tab_powerline_style = "round";
    };
    keybindings = {
      "ctrl+alt+enter" = "launch --cwd=current";
      "ctrl+alt+t" = "new_tab_with_cwd";
      "ctrl+alt+z" = "toggle_layout stack";
      "ctrl+alt+h" = "neighboring_window left";
      "ctrl+alt+j" = "neighboring_window down";
      "ctrl+alt+k" = "neighboring_window up";
      "ctrl+alt+l" = "neighboring_window right";
      "ctrl+alt+shift+h" = "move_window left";
      "ctrl+alt+shift+j" = "move_window down";
      "ctrl+alt+shift+k" = "move_window up";
      "ctrl+alt+shift+l" = "move_window right";
    };
  };

  # A cat clone with wings
  programs.bat = {
    enable = true;
    config = {
      theme = "catppuccin-mocha";
    };
    themes = {
      catppuccin-mocha = {
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "bat";
          rev = "699f60fc8ec434574ca7451b444b880430319941";
          sha256 = "sha256-6fWoCH90IGumAMc4buLRWL0N61op+AuMNN9CAR9/OdI=";
        };
        file = "themes/Catppuccin Mocha.tmTheme";
      };
    };
  };

  # A ls replacement
  programs.eza = {
    enable = true;
  };

  # A `find` replacement
  programs.fd = {
    enable = true;
    hidden = true;
  };

  # A `grep` replacement
  programs.ripgrep = {
    enable = true;
    arguments = [
      "--smart-case"
    ];
  };

  # A command-line fuzzy finder
  programs.fzf = {
    enable = true;
    # The command that gets executed as the source for the ALT-C keybinding
    changeDirWidgetCommand = "fd --type d";
    # Command line options for the ALT-C keybinding
    changeDirWidgetOptions = [
      "--preview 'eza --color=always -T {} | head -200'"
    ];
    colors = {
      "bg+" = "#313244";
      bg = "#1e1e2e";
      spinner = "#f5e0dc";
      hl = "#f38ba8";
      fg = "#cdd6f4";
      header = "#f38ba8";
      info = "#cba6f7";
      pointer = "#f5e0dc";
      marker = "#f5e0dc";
      "fg+" = "#cdd6f4";
      prompt = "#cba6f7";
      "hl+" = "#f38ba8";
    };
    # The command that gets executed as the default source
    defaultCommand = "fd --type f";
    # The options given to fzf by default
    defaultOptions = [
      "--height 40%"
      "--border"
      "--layout=reverse"
    ];
    # The command that gets executed as the source for the CTRL-T keybinding
    fileWidgetCommand = "fd --type f";
    # The options for CTRL-T
    fileWidgetOptions = [
      "--preview 'bat --line-range :20 --color always {}'"
    ];
    # Command line options for the CTRL-R keybind
    historyWidgetOptions = [
      "--scheme=history"
    ];
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
      language-server = {
        rust-analyzer = {
          config.check.command = "clippy";
        };
      };
      language = [
        {
          name = "nix";
          auto-format = true;
          formatter = {
            command = "nixpkgs-fmt";
          };
        }
        {
          name = "javascript";
          auto-format = true;
          formatter = {
            command = "prettier";
            args = [
              "--parser"
              "typescript"
            ];
          };
        }
        {
          name = "typescript";
          auto-format = true;
          formatter = {
            command = "prettier";
            args = [
              "--parser"
              "typescript"
            ];
          };
        }
        {
          name = "tsx";
          auto-format = true;
          formatter = {
            command = "prettier";
            args = [
              "--parser"
              "typescript"
            ];
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
        # Minimum severity to show a diagnostic after the end of a line.
        end-of-line-diagnostics = "hint";
        inline-diagnostics = {
          # Minimum severity to show a diagnostic on the primary cursor's line.
          # These are hidden in insert mode.
          cursor-line = "warning";
          # Minimum severity to show a diagnostic on other lines.
          other-lines = "error";
        };
        lsp = {
          display-messages = true;
          display-progress-messages = true;
          display-inlay-hints = true;
        };
        indent-guides = {
          render = true;
          skip-levels = 1;
        };
        soft-wrap = {
          enable = true;
        };
        popup-border = "all";
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
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };
      ecosystem = {
        no_update_news = true;
        no_donation_nag = true;
      };
      binds = {
        workspace_back_and_forth = true;
      };
      gestures = {
        gesture = "3, horizontal, workspace";
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
        "$mod, M, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ];
      # Keybinds that work while the screen is locked, and that allow press and hold
      bindel = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ] ++ (lib.optionals (builtins.elem pkgs.brightnessctl config.home.packages) [
        ", XF86MonBrightnessUp, exec, brightnessctl set +2%"
        ", XF86MonBrightnessDown, exec, brightnessctl set 2%-"
      ]);
      # Trigger when released
      bindr = [
        ", Print, exec, fish -c ~/bin/screenshot.fish"
      ];
      bind = [
        "$mod, C, killactive"
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
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        "$mod, S, togglespecialworkspace,"
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
        "$mod_SHIFT, 8, movetoworkspacesilent, 8"
        "$mod_SHIFT, 9, movetoworkspacesilent, 9"
        "$mod_SHIFT, 0, movetoworkspacesilent, 10"
        "$mod_SHIFT, S, movetoworkspacesilent, special"
        "$mod_CTRL, H, movecurrentworkspacetomonitor, l"
        "$mod_CTRL, L, movecurrentworkspacetomonitor, r"
        "$mod_CTRL, J, movecurrentworkspacetomonitor, d"
        "$mod_CTRL, K, movecurrentworkspacetomonitor, u"
        "$mod, F, fullscreen, 1" # maximize window (keep bar and gaps)
        "$mod_SHIFT, F, fullscreen, 0" # fullscreen
        "$mod, P, pin, active"
        "$mod_SHIFT, Space, togglefloating, active"
      ] ++ (lib.optionals (config.programs.kitty.enable) [
        "$mod, Return, exec, kitty --single-instance"
      ]) ++ (lib.optionals (config.services.playerctld.enable) [
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioStop, exec, playerctl stop"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioNext, exec, playerctl next"
      ]);
      windowrulev2 = [
        "float,class:^(firefox)$,title:^(Picture-in-Picture)$"
        "float,class:^(com.gabm.satty)$,title:^(satty)$"
        # This is necessary because for some reason certain
        # drag-and-drop operations are broken in Ardour on Hyprland.
        # (For example, dragging a plugin up or down in the effects/plugin stack)
        "nofocus,class:^(Ardour-)(.*)$,title:^(Ardour)$"
      ];
      exec-once = [
        "swww-daemon"
        "~/bin/wallpapers.fish"
      ];
    };
    extraConfig = ''
      bind=$mod,escape,submap,powermenu
      submap=powermenu
      bind=,l,exec,swaylock --effect-scale 0.5 --effect-blur 7x5 --effect-scale 2
      bind=,l,submap,reset
      bind=,e,exit
      bind=,e,submap,reset
      bind=SHIFT,S,exec,systemctl poweroff --no-wall
      bind=SHIFT,S,submap,reset
      bind=SHIFT,R,exec,systemctl reboot --no-wall
      bind=SHIFT,R,submap,reset
      bind=,escape,submap,reset
      submap=reset
    '';
  };

  programs.obs-studio = {
    enable = true;
    plugins = [
      pkgs.obs-studio-plugins.obs-vaapi
    ];
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

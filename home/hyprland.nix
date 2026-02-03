{ pkgs, lib, config, ... }:
{
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
      windowrule = [
        "match:float true,match:class ^(firefox)$,match:title ^(Picture-in-Picture)$"
        "match:float true,match:class ^(com.gabm.satty)$,match:title ^(satty)$"
        # This is necessary because for some reason certain
        # drag-and-drop operations are broken in Ardour on Hyprland.
        # (For example, dragging a plugin up or down in the effects/plugin stack)
        "match:focus false,match:class ^(Ardour-)(.*)$,match:title ^(Ardour)$"
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
}

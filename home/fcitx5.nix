{ pkgs, lib, config, ... }:
{
  config = lib.mkIf config.localhost.enable {
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        addons = [
          pkgs.fcitx5-mozc-ut
          pkgs.catppuccin-fcitx5
        ];
        settings.inputMethod = {
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "de-nodeadkeys";
            DefaultIM = "mozc";
          };
          "Groups/0/Items/0".Name = "keyboard-de-nodeadkeys";
          "Groups/0/Items/1".Name = "mozc";
        };
        settings.globalOptions = {
          Hotkey = {
            EnumerateForwardKeys = "";
            EnumerateBackwardKeys = "";
            EnumerateGroupForwardKeys = "";
            EnumerateGroupBackwardKeys = "";
          };
          "Behavior/DisabledAddons"."0" = "clipboard";
        };
        settings.addons = {
          classicui.globalSection = {
            Font = "Sans 14";
            MenuFont = "Sans 14";
            Theme = "catppuccin-mocha-mauve";
          };
          keyboard.globalSection = {
            "Hint Trigger" = "";
            "One Time Hint Trigger" = "";
          };
        };
      };
    };
  };
}

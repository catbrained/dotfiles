{ ... }:
{
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
}

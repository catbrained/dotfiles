{ ... }:
{
  config = {
    # A command-line fuzzy finder
    programs.fzf = {
      enable = true;
      # The command that gets executed as the source for the ALT-C keybinding
      changeDirWidget.command = "fd --type d";
      # Command line options for the ALT-C keybinding
      changeDirWidget.options = [
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
      fileWidget.command = "fd --type f";
      # The options for CTRL-T
      fileWidget.options = [
        "--preview 'bat --line-range :20 --color always {}'"
      ];
      # Command line options for the CTRL-R keybind
      historyWidget.options = [
        "--scheme=history"
      ];
    };
  };
}

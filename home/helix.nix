{ pkgs, ... }:
{
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
}

{ lib, config, ... }:
{
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
}

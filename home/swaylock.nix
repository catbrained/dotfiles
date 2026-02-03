{ pkgs, ... }:
{
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
}

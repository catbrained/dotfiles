{ lib, config, ... }:
{
  config = lib.mkIf config.localhost.enable {
    programs.mpv = {
      enable = true;
    };
  };
}

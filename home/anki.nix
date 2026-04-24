{ config, lib, ... }:
{
  config = lib.mkIf config.localhost.enable {
    programs.anki = {
      enable = true;
    };
  };
}

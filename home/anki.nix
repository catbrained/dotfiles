{ config, lib, ... }:
{
  config = lib.mkIf config.localhost-extra.enable {
    programs.anki = {
      enable = true;
    };
  };
}

{ lib, config, ... }:
{
  config = lib.mkIf config.localhost.enable {
    programs.firefox = {
      enable = true;
    };
  };
}

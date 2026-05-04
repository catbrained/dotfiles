{ lib, config, ... }:
{
  config = lib.mkIf config.localhost.enable {
    programs.firefox = {
      enable = true;
      configPath = "${config.xdg.configHome}/mozilla/firefox";
    };
  };
}

{ pkgs, lib, config, ... }:
{
  config = lib.mkIf config.localhost.enable {
    programs.obs-studio = {
      enable = true;
      plugins = [
        pkgs.obs-studio-plugins.obs-vaapi
      ];
    };
  };
}

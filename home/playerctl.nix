{ pkgs, lib, config, ... }:
{
  config = lib.mkIf config.localhost.enable {
    home.packages = [
      pkgs.playerctl
    ];

    services.playerctld = {
      enable = true;
    };
  };
}

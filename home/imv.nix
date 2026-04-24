{ lib, config, ... }:
{
  config = lib.mkIf config.localhost.enable {
    # image viewer
    programs.imv = {
      enable = true;
    };
  };
}

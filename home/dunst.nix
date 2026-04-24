{ lib, config, ... }:
{
  config = lib.mkIf config.localhost.enable {
    # Notification daemon
    services.dunst = {
      enable = false;
    };
  };
}

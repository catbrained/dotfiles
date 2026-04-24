{ lib, config, ... }:
{
  config = lib.mkIf config.localhost.enable {
    # Shell prompt
    programs.starship = {
      enable = true;
      settings = { };
    };
  };
}

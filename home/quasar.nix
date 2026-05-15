{ ... }:
{
  imports = [
    ./home.nix
  ];

  config = {
    localhost.enable = true;
    localhost-extra.enable = true;
  };
}

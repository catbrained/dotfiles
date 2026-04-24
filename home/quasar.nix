{ ... }:
{
  imports = [
    ./home.nix
  ];

  config = {
    localhost.enable = true;
  };
}

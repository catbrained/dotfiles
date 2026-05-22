{ pkgs, ... }:
{
  imports = [
    ./home.nix
  ];

  config = {
    localhost.enable = true;
    home.packages = [
      pkgs.nmap
      pkgs.wordlists
      pkgs.inetutils
    ];
  };
}

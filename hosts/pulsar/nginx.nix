{ pkgs, ... }:
{
  config = {
    services.nginx = {
      package = pkgs.nginxMainline;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedTlsSettings = true;
    };
  };
}

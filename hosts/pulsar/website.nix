{ ... }:
{
  config =
    let
      domain = "catbrained.dev";
    in
    {
      networking.firewall.allowedTCPPorts = [ 80 443 ];
      services.nginx = {
        enable = true;
        virtualHosts."www.${domain}" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            return = "200 '<html><body>It works</body></html>'";
            extraConfig = ''
              default_type text/html;
            '';
          };
        };
        virtualHosts."${domain}" = {
          useACMEHost = "www.${domain}";
          forceSSL = true;
          globalRedirect = "www.${domain}";
        };
      };
      security.acme = {
        certs."www.${domain}".extraDomainNames = [
          "${domain}"
        ];
      };
    };
}

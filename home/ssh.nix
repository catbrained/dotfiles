{ ... }:
{
  config = {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = {
        "*" = {
          forwardAgent = false;
          addKeysToAgent = "confirm 20m";
          compression = false;
          serverAliveInterval = 0;
          serverAliveCountMax = 3;
          hashKnownHosts = false;
          userKnownHostsFile = "~/.ssh/known_hosts";
          controlMaster = "no";
          controlPath = "~/.ssh/master-%r@%n:%p";
          controlPersist = "no";
        };
        "pulsar" = {
          hostname = "89.58.12.21";
          port = 52783;
        };
      };
      extraConfig = ''
        PasswordAuthentication no
      '';
    };

    services.ssh-agent.enable = true;
  };
}

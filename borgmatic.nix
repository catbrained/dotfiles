{ config, ... }:
{
  services.borgmatic = {
    enable = true;
    configurations.quasar = {
      repositories = [
        {
          path = "ssh://v5uzraul@v5uzraul.repo.borgbase.com/./repo";
          label = "quasar on BorgBase";
        }
      ];
      source_directories = [
        "/home/linda/audio"
        "/home/linda/documents"
        "/home/linda/pictures"
        "/home/linda/videos"
      ];
      keep_hourly = 24;
      keep_daily = 7;
      keep_weekly = 4;
      keep_monthly = 12;
      keep_yearly = 10;
      retries = 5;
      retry_wait = 5;
      skip_actions = [
        "check"
      ];
      check_last = 3;
      compression = "auto,zstd";
      archive_name_format = "quasar-{now:%Y-%m-%d-%H%M%S}";
      encryption_passcommand = "cat ${config.sops.secrets."borgmatic/quasar/encryption_password".path}";
      ssh_command = "ssh -i /home/linda/.ssh/id_borgbase";
    };
  };

  systemd.timers.borgmatic = {
    timerConfig = {
      OnCalendar = "hourly";
    };
  };
}

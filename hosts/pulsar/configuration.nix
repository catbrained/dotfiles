{ ... }:
{
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.11";

  users.users.testuser = {
    initialPassword = "test";
    isNormalUser = true;
    group = "testuser";
  };

  users.groups.testuser = { };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_TIME = "en_DK.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
  };
  console = {
    # Let the kernel pick a suitable font depending on resolution
    font = null;
    useXkbConfig = true; # use xkbOptions in tty.
  };

  # Configure keymap in X11
  services.xserver = {
    xkb = {
      layout = "de";
      variant = "nodeadkeys";
      # Make caps lock an additional esc, both shifts together enable caps lock
      options = "caps:escape,shift:both_capslock";
    };
  };
}

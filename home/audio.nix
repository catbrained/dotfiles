{ pkgs, lib, ... }:
{
  home.packages = [
    pkgs.audacity
    pkgs.ardour # DAW
    pkgs.vital # wavetable synth
    pkgs.geonkick # drums
    pkgs.lsp-plugins # lots of nice audio plugins
    pkgs.guitarix # Guitar plugins
    pkgs.carla # Plugin host & patchbay
  ];

  home.sessionVariables =
    let
      makePluginPath = format:
        (lib.makeSearchPath format [
          "$HOME/.nix-profile/lib"
          "/run/current-system/sw/lib"
          "/etc/profiles/per-user/$USER/lib"
        ])
        + ":$HOME/.${format}";
    in
    {
      DSSI_PATH = makePluginPath "dssi";
      LADSPA_PATH = makePluginPath "ladspa";
      LV2_PATH = makePluginPath "lv2";
      LXVST_PATH = makePluginPath "lxvst";
      VST_PATH = makePluginPath "vst";
      VST3_PATH = makePluginPath "vst3";
    };
}

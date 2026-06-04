{ pkgs, ... }: {
  # Generic laptop add-ons on top of the workstation profile: TLP for
  # battery management, brightness keys, lid behaviour, and the autologin
  # convenience (skip the SDDM prompt). Hardware-CPU tuning (intel vs amd)
  # is per-host — pull in modules/intel-laptop.nix or modules/amd-laptop.nix
  # in the host file itself.
  imports = [
    ./workstation.nix
    ../plasma6/autologin.nix
  ];

  # Power-profiles-daemon would clash with TLP.
  services.power-profiles-daemon.enable = false;
  services.tlp.enable = true;

  # Brightness keys + backlight.
  programs.light.enable = true;

  # Lid + idle handled at Plasma level (see plasma6/config.nix powerdevilrc).
  # The systemd defaults are kept conservative here.
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "ignore";
  };
}

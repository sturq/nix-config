{ pkgs, ... }: {
  # Opinionated laptop bits on top of whatever common-* / device modules
  # nixos-hardware provides. Power-profiles-daemon out, TLP in, brightness
  # keys, lid → suspend on battery / ignore on AC.

  services.power-profiles-daemon.enable = false;
  services.tlp.enable = true;

  programs.light.enable = true;

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "ignore";
  };

  # AC vs battery TLP defaults that work well on every laptop we've tried.
  services.tlp.settings = {
    CPU_SCALING_GOVERNOR_ON_AC = "performance";
    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    CPU_BOOST_ON_AC = 1;
    CPU_BOOST_ON_BAT = 0;
    PCIE_ASPM_ON_AC = "default";
    PCIE_ASPM_ON_BAT = "powersupersave";
    WIFI_PWR_ON_AC = "off";
    WIFI_PWR_ON_BAT = "on";
    START_CHARGE_THRESH_BAT0 = 75;
    STOP_CHARGE_THRESH_BAT0 = 90;
  };
}

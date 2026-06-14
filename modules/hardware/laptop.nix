{ pkgs, lib, ... }: {
  # Generic laptop bits: TLP for power, brightness keys, lid → suspend
  # on battery / ignore on AC. Works on any Intel/AMD laptop.

  services.power-profiles-daemon.enable = false;
  services.tlp.enable = true;
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

  hardware.acpilight.enable = true;
  environment.systemPackages = [ pkgs.brightnessctl ];

  services.logind.settings.Login = {
    HandleLidSwitch = lib.mkDefault "suspend";
    HandleLidSwitchExternalPower = lib.mkDefault "ignore";
  };
}

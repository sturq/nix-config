{ pkgs, lib, ... }: {
  imports = [
    ../../modules/base.nix
    ../../modules/grub.nix
    ../../modules/kernel.nix
    ../../modules/audio.nix
    ../../modules/fonts.nix
    ../../modules/kernel-tuning.nix
    ../../modules/stylix.nix
    ../../modules/dev-defaults.nix
    ../../modules/desktop-environments/plasma6.nix
    ../../modules/login-managers/sddm.nix
    ../../modules/keepassxc.nix
    ../../modules/tailscale.nix
  ];

  networking.hostName = "laptop";
  system.stateVersion = "25.11";

  # ---- Laptop bits ----------------------------------------------------
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

  # Brightness keys (light was removed from nixpkgs).
  hardware.acpilight.enable = true;
  environment.systemPackages = [ pkgs.brightnessctl ];

  # Lid: suspend on battery, ignore when docked on AC.
  services.logind.settings.Login = {
    HandleLidSwitch = lib.mkDefault "suspend";
    HandleLidSwitchExternalPower = lib.mkDefault "ignore";
  };
}

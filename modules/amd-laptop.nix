{ pkgs, lib, ... }: {
  # ASUS Vivobook S 14 (M5406WA) — AMD Ryzen AI 9 HX 370 (Strix Point, Zen 5).

  # ASUS power/fan profiles, charge limit, etc.
  # The user service is started automatically by asusd in current versions.
  services.asusd.enable = true;

  # Power profiles (Quiet/Balanced/Performance) — pairs with asusd
  services.power-profiles-daemon.enable = true;

  # Firmware updates
  services.fwupd.enable = true;

  # AMD iGPU (Radeon 890M, RDNA 3.5)
  hardware.graphics.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Kernel params: amd_pstate (matches Windows scheduler on Zen 5),
  # PSR-SU (panel self-refresh saves 1-2W idle), PCIe ASPM aggressive.
  boot.kernelParams = [
    "amd_pstate=active"
    "amdgpu.dcdebugmask=0x10"
    "pcie_aspm=force"
    "pcie_aspm.policy=powersupersave"
  ];

  # Cap battery at 80% by default for longevity
  systemd.services.battery-charge-limit = {
    description = "Set ASUS battery charge limit to 80%";
    wantedBy = [ "multi-user.target" ];
    after = [ "asusd.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.asusctl}/bin/asusctl -c 80";
    };
  };
}

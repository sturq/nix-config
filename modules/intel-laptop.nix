{ pkgs, lib, ... }: {
  # Generic Intel laptop tuning — TLP auto-switches AC=performance vs BAT=savings.

  hardware.cpu.intel.updateMicrocode = true;
  hardware.graphics.enable = true;

  services.thermald.enable = true;
  services.fwupd.enable = true;

  # TLP — auto-switches between performance (AC) and powersave (battery).
  # Conflicts with power-profiles-daemon — keep PPD disabled.
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      # CPU
      CPU_SCALING_GOVERNOR_ON_AC      = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT     = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC    = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT   = "power";
      CPU_BOOST_ON_AC                 = 1;
      CPU_BOOST_ON_BAT                = 0;
      CPU_HWP_DYN_BOOST_ON_AC         = 1;
      CPU_HWP_DYN_BOOST_ON_BAT        = 0;

      # Platform / Intel pstate
      PLATFORM_PROFILE_ON_AC          = "performance";
      PLATFORM_PROFILE_ON_BAT         = "low-power";

      # PCIe ASPM (kernel param sets default; TLP overrides per AC/BAT)
      PCIE_ASPM_ON_AC                 = "default";
      PCIE_ASPM_ON_BAT                = "powersupersave";

      # Runtime PM for devices
      RUNTIME_PM_ON_AC                = "on";
      RUNTIME_PM_ON_BAT               = "auto";

      # WiFi
      WIFI_PWR_ON_AC                  = "off";
      WIFI_PWR_ON_BAT                 = "on";

      # Battery longevity (works on most HPs; harmless if model doesn't support)
      START_CHARGE_THRESH_BAT0        = 75;
      STOP_CHARGE_THRESH_BAT0         = 90;
    };
  };

  # Bluetooth available but OFF by default — saves ~0.5 W idle.
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;

  # NOTE: lid/idle policy left for the host to decide.

  # Kernel params for max savings when battery — TLP toggles ASPM at runtime.
  boot.kernelParams = [
    "i915.enable_psr=1"
    "i915.enable_fbc=1"
    "pcie_aspm=force"
    "nvme.noacpi=1"
    "mem_sleep_default=deep"
  ];
}

{ pkgs, lib, ... }: {
  # Generic Intel laptop tuning — biased toward battery life.

  hardware.cpu.intel.updateMicrocode = true;
  hardware.graphics.enable = true;

  services.thermald.enable = true;
  services.power-profiles-daemon.enable = true;
  services.fwupd.enable = true;

  # Bluetooth available but OFF by default — saves ~0.5 W idle.
  # Enable on demand: `bluetoothctl power on`.
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;

  # WiFi power management on (sleeps radio when idle).
  networking.networkmanager.wifi.powersave = true;

  # NOTE: lid/idle policy intentionally left for the host to decide.
  # Default NixOS = suspend on lid close, which is fine for prod laptops.
  # Dev hosts (hp250) override to "ignore" + disable idle suspend.

  # Aggressive power tuning at boot.
  boot.kernelParams = [
    "i915.enable_psr=1"              # Panel Self-Refresh: ~1 W saving
    "i915.enable_fbc=1"              # Framebuffer compression
    "pcie_aspm=force"                # PCIe Active State Power Management
    "pcie_aspm.policy=powersupersave"
    "nvme.noacpi=1"                  # Better NVMe sleep on some laptops
    "mem_sleep_default=deep"         # Use S3 instead of s2idle (deeper sleep)
  ];
}

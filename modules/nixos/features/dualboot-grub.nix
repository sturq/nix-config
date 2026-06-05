{ ... }: {
  # Switch the bootloader from systemd-boot to GRUB and let os-prober pick
  # up other OSes on the same disk (typically Windows for dual-boot setups).
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable = true;
    device = "nodev";       # EFI install — GRUB doesn't go on a partition
    efiSupport = true;
    useOSProber = true;
    configurationLimit = 10;
    # Always boot the newest gen — `saved` drifts during rollback testing.
    default = 0;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
}

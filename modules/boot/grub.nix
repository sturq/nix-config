{ ... }: {
  # UEFI GRUB. Keeps the existing dual-boot menu intact on hosts that
  # have one; dualboot-grub.nix adds the Windows entry on top.
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
  };
  boot.loader.efi.canTouchEfiVariables = true;
}

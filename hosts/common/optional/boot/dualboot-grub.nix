{ pkgs, ... }: {
  # GRUB + os-prober for dual-boot. No theme — both our custom roll
  # AND Stylix's grub target produce broken PNGs (132 bytes each, GRUB
  # rejects them and shows an 'any key to continue' prompt). Plain
  # text menu on a black background is uglier but actually works on
  # this hardware family.
  boot.loader.systemd-boot.enable = false;
  stylix.targets.grub.enable = false;

  boot.loader.grub = {
    enable = true;
    device = "nodev";          # EFI install
    efiSupport = true;
    useOSProber = true;
    configurationLimit = 10;
    default = 0;
    timeoutStyle = "menu";

    # Empty splash so NixOS doesn't ship the broken Stylix-generated
    # PNG. Plain black text-mode GRUB.
    splashImage = null;

    memtest86.enable = true;

    # Power/firmware shortcuts so the user doesn't have to spam F-keys to
    # reach UEFI setup. fwsetup / reboot / halt are GRUB built-ins.
    extraEntries = ''
      menuentry "Reboot to UEFI Firmware Settings" --class restart {
        fwsetup
      }
      menuentry "Reboot" --class reboot {
        reboot
      }
      menuentry "Power Off" --class shutdown {
        halt
      }
    '';
  };

  boot.loader.timeout = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
}

{ pkgs, ... }: {
  # GRUB + os-prober for dual-boot. Theme is owned by Stylix (writes a
  # palette-derived dark theme into /boot/theme). Custom-rolled themes
  # broke on this hardware — Intel GOP rejects gfxmode=auto on some
  # resolutions and grub-mkfont .pf2 files we shipped wouldn't load,
  # dropping GRUB into text-mode-blue with an "any key to continue"
  # prompt. Stylix's grub target is what other multi-host nix-config
  # repos use and is proven on this exact chipset family.
  boot.loader.systemd-boot.enable = false;

  boot.loader.grub = {
    enable = true;
    device = "nodev";          # EFI install
    efiSupport = true;
    useOSProber = true;
    configurationLimit = 10;
    default = 0;
    timeoutStyle = "menu";

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

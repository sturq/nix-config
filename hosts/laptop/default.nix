{ ... }: {
  imports = [
    # nix
    ../../modules/nix/flakes.nix
    ../../modules/nix/allow-unfree.nix
    # user + locale
    ../../modules/users/sturq.nix
    ../../modules/locale/de-keymap.nix
    ../../modules/locale/en-gb.nix
    ../../modules/locale/geo-timezone.nix
    # boot + kernel
    ../../modules/boot/grub.nix
    ../../modules/kernel/latest.nix
    ../../modules/kernel/tuning.nix
    # hardware
    ../../modules/hardware/cpu-microcode.nix
    ../../modules/hardware/graphics.nix
    ../../modules/hardware/bluetooth.nix
    ../../modules/hardware/fstrim.nix
    ../../modules/hardware/laptop.nix
    # networking
    ../../modules/networking/networkmanager.nix
    # services
    ../../modules/services/audio.nix
    ../../modules/services/dev-defaults.nix
    ../../modules/services/tailscale.nix
    # ui
    ../../modules/theme/fonts.nix
    ../../modules/theme/stylix.nix
    ../../modules/desktop-environments/plasma6.nix
    ../../modules/login-managers/sddm.nix
    # apps
    ../../modules/applications/keepassxc.nix
  ];

  networking.hostName = "laptop";
  system.stateVersion = "25.11";
}

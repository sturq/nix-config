{ ... }: {
  # HP 250 G9 — Intel laptop, Windows dual-boot, Steam + Sober for gaming.
  imports = [
    ../../modules/profiles/laptop.nix
    ../../modules/intel-laptop.nix       # i915 PSR/FBC, deep S3, thermald
  ];

  networking.hostName = "hp250";

  # GRUB + os-prober — detects Windows dual-boot automatically.
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable = true;
    device = "nodev";       # EFI, GRUB doesn't go on a partition
    efiSupport = true;
    useOSProber = true;     # scan + add Windows etc. to GRUB menu
    configurationLimit = 10;
    # Always boot the newest gen — `saved` drifts during rollback testing.
    default = 0;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  # Dev override of the laptop default (which suspends on lid-close):
  # this machine stays on always.
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    IdleAction = "ignore";
  };

  # Steam (with all the NixOS magic: wrapping, fonts, native libs).
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = false;
  };

  # Sober (Roblox via Vinegar) — declarative Flatpak install.
  services.flatpak.enable = true;
  services.flatpak.packages = [ "org.vinegarhq.Sober" ];
}

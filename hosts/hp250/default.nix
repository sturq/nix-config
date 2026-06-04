{ pkgs, lib, ... }: {
  imports = [
    # hardware-configuration.nix imported by flake (mkHost / mkInstaller)
    ../../modules/base.nix
    ../../modules/desktop
    ../../modules/desktop/autologin.nix  # dev convenience — skip tuigreet
    ../../modules/intel-laptop.nix
    ../../modules/stylix.nix
    ../../modules/tailscale.nix
  ];

  # GRUB + os-prober — detects Windows dual-boot automatically.
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable = true;
    device = "nodev";       # EFI, GRUB doesn't go on a partition
    efiSupport = true;
    useOSProber = true;     # scan + add Windows etc. to GRUB menu
    configurationLimit = 10;
    # Always boot the newest NixOS generation. We do *not* use `saved` here
    # because the saved-choice can drift to an old gen during rollback testing.
    default = 0;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  # Allow os-prober to read other-OS partitions for boot-menu generation.
  nixpkgs.config.allowUnfree = true;

  networking.hostName = "hp250";

  # Dev machine — never auto-suspend, ignore lid close.
  services.logind.lidSwitch = "ignore";
  services.logind.lidSwitchExternalPower = "ignore";
  services.logind.settings.Login.IdleAction = "ignore";

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
    settings.PermitRootLogin = "yes";
  };

  users.users.sturq.initialPassword = "install";
  users.users.root.initialPassword = "install";

  # Steam (with all the NixOS-magic: wrapping, fonts, native libs)
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = false;
  };

  # Sober (Roblox via Vinegar) — declarative Flatpak install.
  services.flatpak.enable = true;
  services.flatpak.packages = [
    "org.vinegarhq.Sober"
  ];

  system.stateVersion = "25.11";
}

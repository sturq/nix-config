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

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 3;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

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

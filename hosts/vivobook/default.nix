{ pkgs, lib, ... }: {
  imports = [
    # hardware-configuration.nix imported by flake (mkHost / mkInstaller)
    ../../modules/base.nix
    ../../modules/desktop
    ../../modules/amd-laptop.nix
    ../../modules/tailscale.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 3;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  networking.hostName = "vivobook";

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
    settings.PermitRootLogin = "yes";
  };

  users.users.sturq.initialPassword = "install";
  users.users.root.initialPassword = "install";

  system.stateVersion = "25.11";
}

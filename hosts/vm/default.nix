{ pkgs, ... }: {
  imports = [
    # hardware-configuration.nix imported by flake (mkHost / mkInstaller)
    ../../modules/base.nix
    ../../modules/plasma6
    ../../modules/plasma6/autologin.nix  # VM sandbox — skip greeter
    ../../modules/tailscale.nix
  ];

  networking.hostName = "dev-nixos";

  users.users.sturq.initialPassword = "install";
  users.users.root.initialPassword = "install";

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
    settings.PermitRootLogin = "yes";
  };

  services.qemuGuest.enable = true;

  system.stateVersion = "25.11";
}

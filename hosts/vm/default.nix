{ ... }: {
  # Proxmox test VM — virtual desktop sandbox.
  imports = [
    ../../modules/base.nix
    ../../modules/stylix.nix
    ../../modules/desktop/plasma6
    ../../modules/desktop/plasma6/autologin.nix
    ../../modules/hardware/desktop.nix
    ../../modules/features/tailscale.nix
    ../../modules/features/dev-defaults.nix
  ];

  networking.hostName = "dev-nixos";
  system.stateVersion = "25.11";

  services.qemuGuest.enable = true;
}

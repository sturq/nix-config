{ ... }: {
  # Proxmox test VM — virtual desktop sandbox.
  imports = [
    ../../modules/nixos/base.nix
    ../../modules/nixos/stylix.nix
    ../../modules/nixos/desktop/plasma6
    ../../modules/nixos/desktop/plasma6/autologin.nix
    ../../modules/nixos/hardware/desktop.nix
    ../../modules/nixos/features/tailscale.nix
    ../../modules/nixos/features/dev-defaults.nix
  ];

  networking.hostName = "dev-nixos";
  system.stateVersion = "25.11";

  services.qemuGuest.enable = true;
}

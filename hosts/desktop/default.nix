{ ... }: {
  # Generic desktop host — deploy via nixos-anywhere onto any tower.
  imports = [
    ../../modules/nixos/base.nix
    ../../modules/nixos/stylix.nix
    ../../modules/nixos/desktop/plasma6
    ../../modules/nixos/hardware/desktop.nix
    ../../modules/nixos/features/tailscale.nix
    ../../modules/nixos/features/dev-defaults.nix
  ];

  networking.hostName = "desktop";
  system.stateVersion = "25.11";
}

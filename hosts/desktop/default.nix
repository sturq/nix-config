{ ... }: {
  # Generic desktop host — deploy via nixos-anywhere onto any tower.
  imports = [
    ../../modules/base.nix
    ../../modules/stylix.nix
    ../../modules/desktop/plasma6
    ../../modules/hardware/desktop.nix
    ../../modules/features/tailscale.nix
    ../../modules/features/dev-defaults.nix
  ];

  networking.hostName = "desktop";
  system.stateVersion = "25.11";
}

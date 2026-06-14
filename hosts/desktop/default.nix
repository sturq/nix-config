{ ... }: {
  # Generic desktop host — deploy via nixos-anywhere onto any tower.
  imports = [
    ../../modules/nixos/desktop/plasma.nix
    ../../modules/nixos/hardware/desktop.nix
    ../../modules/nixos/services/tailscale.nix
    ../../modules/nixos/services/dev-defaults.nix
  ];

  networking.hostName = "desktop";
  system.stateVersion = "25.11";
}

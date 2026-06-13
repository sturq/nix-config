{ ... }: {
  # Generic desktop host — deploy via nixos-anywhere onto any tower.
  imports = [
    ../common/optional/desktop/plasma.nix
    ../common/optional/hardware/desktop.nix
    ../common/optional/services/tailscale.nix
    ../common/optional/dev-defaults.nix
  ];

  networking.hostName = "desktop";
  system.stateVersion = "25.11";
}

{ ... }: {
  # Generic desktop host — deploy via nixos-anywhere onto any tower.
  imports = [
    ../common/optional/plasma6.nix
    ../common/optional/hardware/desktop.nix
    ../common/optional/tailscale.nix
    ../common/optional/dev-defaults.nix
  ];

  networking.hostName = "desktop";
  system.stateVersion = "25.11";
}

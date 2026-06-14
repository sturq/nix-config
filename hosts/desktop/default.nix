{ ... }: {
  # Generic desktop host — deploy via nixos-anywhere onto any tower.
  imports = [
    ../../desktop-environment/system
    ../../display-manager
    ../../applications
    ../../modules/nixos/hardware/desktop.nix
    ../../modules/nixos/services/tailscale.nix
    ../../modules/nixos/services/dev-defaults.nix
  ];

  networking.hostName = "desktop";
  system.stateVersion = "25.11";
}

{ ... }: {
  # Generic laptop host — deploy via nixos-anywhere onto any Intel/AMD laptop.
  imports = [
    ../../desktop-environment/system
    ../../display-manager
    ../../applications
    ../../modules/nixos/hardware/laptop.nix
    ../../modules/nixos/services/tailscale.nix
    ../../modules/nixos/services/dev-defaults.nix
  ];

  networking.hostName = "laptop";
  system.stateVersion = "25.11";
}

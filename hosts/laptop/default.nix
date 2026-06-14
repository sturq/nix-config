{ ... }: {
  # Generic laptop host — deploy via nixos-anywhere onto any Intel/AMD laptop.
  # Pick CPU/GPU specific common-* modules in a real host (hp250, vivobook).
  imports = [
    ../../modules/nixos/desktop/plasma.nix
    ../../modules/nixos/hardware/laptop.nix
    ../../modules/nixos/services/tailscale.nix
    ../../modules/nixos/services/dev-defaults.nix
  ];

  networking.hostName = "laptop";
  system.stateVersion = "25.11";
}

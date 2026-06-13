{ ... }: {
  # Generic laptop host — deploy via nixos-anywhere onto any Intel/AMD laptop.
  # Pick CPU/GPU specific common-* modules in a real host (hp250, vivobook).
  imports = [
    ../common/optional/plasma6.nix
    ../common/optional/hardware/laptop.nix
    ../common/optional/tailscale.nix
    ../common/optional/dev-defaults.nix
  ];

  networking.hostName = "laptop";
  system.stateVersion = "25.11";
}

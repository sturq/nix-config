{ ... }: {
  # Generic laptop host — deploy via nixos-anywhere onto any Intel/AMD laptop.
  # Pick CPU/GPU specific common-* modules in a real host (hp250, vivobook).
  imports = [
    ../../modules/nixos/base.nix
    ../../modules/nixos/stylix.nix
    ../../modules/nixos/desktop/plasma6
    ../../modules/nixos/desktop/plasma6/autologin.nix
    ../../modules/nixos/hardware/laptop.nix
    ../../modules/nixos/features/tailscale.nix
    ../../modules/nixos/features/dev-defaults.nix
  ];

  networking.hostName = "laptop";
  system.stateVersion = "25.11";
}

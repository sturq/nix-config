{ ... }: {
  # Generic laptop host — deploy via nixos-anywhere onto any Intel/AMD laptop.
  # Pick CPU/GPU specific common-* modules in a real host (hp250, vivobook).
  imports = [
    ../../modules/base.nix
    ../../modules/stylix.nix
    ../../modules/desktop/plasma6
    ../../modules/desktop/plasma6/autologin.nix
    ../../modules/hardware/laptop.nix
    ../../modules/features/tailscale.nix
    ../../modules/features/dev-defaults.nix
  ];

  networking.hostName = "laptop";
  system.stateVersion = "25.11";
}

{ ... }: {
  # Generic laptop host — deploy via nixos-anywhere onto any Intel/AMD laptop.
  imports = [
    ../common/global
    ../common/optional/plasma6
    ../common/optional/sddm
    ../common/optional/applications
    ../common/optional/hardware/laptop.nix
    ../common/optional/tailscale.nix
  ];

  networking.hostName = "laptop";
  system.stateVersion = "25.11";
}

{ ... }: {
  # Generic desktop host — deploy via nixos-anywhere onto any tower.
  imports = [
    ../common/global
    ../common/optional/plasma6
    ../common/optional/sddm
    ../common/optional/applications
    ../common/optional/hardware/desktop.nix
    ../common/optional/tailscale.nix
  ];

  networking.hostName = "desktop";
  system.stateVersion = "25.11";
}

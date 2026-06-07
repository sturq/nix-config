{ ... }: {
  # Proxmox test VM — virtual desktop sandbox.
  imports = [
    ../common/optional/plasma6.nix
    ../common/optional/autologin.nix
    ../common/optional/hardware/desktop.nix
    ../common/optional/tailscale.nix
    ../common/optional/dev-defaults.nix
  ];

  networking.hostName = "dev-nixos";
  system.stateVersion = "25.11";

  services.qemuGuest.enable = true;
}

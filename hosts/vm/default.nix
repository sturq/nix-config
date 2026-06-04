{ ... }: {
  # Proxmox test VM — no battery, no lid, qemu-guest-agent.
  imports = [
    ../../modules/profiles/desktop.nix
    ../../modules/plasma6/autologin.nix  # sandbox — skip greeter
  ];

  networking.hostName = "dev-nixos";

  services.qemuGuest.enable = true;
}

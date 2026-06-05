{ inputs, ... }: {
  # ASUS Vivobook S 14 M5406WA — AMD Strix Point laptop.
  imports = [
    ../../modules/nixos/base.nix
    ../../modules/nixos/stylix.nix
    ../../modules/nixos/desktop/plasma6
    ../../modules/nixos/desktop/plasma6/autologin.nix
    ../../modules/nixos/hardware/laptop.nix
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    ../../modules/nixos/features/tailscale.nix
    ../../modules/nixos/features/dev-defaults.nix
  ];

  networking.hostName = "vivobook";
  system.stateVersion = "25.11";

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 3;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
}

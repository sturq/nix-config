{ inputs, ... }: {
  # ASUS Vivobook S 14 M5406WA — AMD Strix Point laptop.
  imports = [
    ../../modules/base.nix
    ../../modules/stylix.nix
    ../../modules/desktop/plasma6
    ../../modules/desktop/plasma6/autologin.nix
    ../../modules/hardware/laptop.nix
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    ../../modules/features/tailscale.nix
    ../../modules/features/dev-defaults.nix
  ];

  networking.hostName = "vivobook";
  system.stateVersion = "25.11";

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 3;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
}

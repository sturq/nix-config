{ inputs, ... }: {
  # ASUS Vivobook S 14 M5406WA — AMD Strix Point laptop.
  imports = [
    ../../modules/nixos/desktop/plasma.nix
    ../../modules/nixos/hardware/laptop.nix
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    ../../modules/nixos/services/tailscale.nix
    ../../modules/nixos/services/dev-defaults.nix
  ];

  networking.hostName = "vivobook";
  system.stateVersion = "25.11";

  # global already enables systemd-boot + canTouchEfiVariables.
  boot.loader.systemd-boot.configurationLimit = 3;
}

{ inputs, ... }: {
  # HP 250 G9 — Intel laptop, Windows dual-boot, Steam + Sober for gaming.
  imports = [
    ../../modules/nixos/base.nix
    ../../modules/nixos/stylix.nix
    ../../modules/nixos/desktop/plasma6
    ../../modules/nixos/hardware/laptop.nix
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    ../../modules/nixos/features/tailscale.nix
    ../../modules/nixos/features/dev-defaults.nix
    ../../modules/nixos/features/dualboot-grub.nix
    ../../modules/nixos/features/steam.nix
    ../../modules/nixos/features/flatpak.nix
  ];

  networking.hostName = "hp250";
  system.stateVersion = "25.11";

  # Dev override of the laptop default (which suspends on lid-close):
  # this machine stays on always.
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    IdleAction = "ignore";
  };

  # Skip the SDDM greeter on this dev box.
  services.displayManager.autoLogin = {
    enable = true;
    user = "sturq";
  };

  services.flatpak.packages = [ "org.vinegarhq.Sober" ];
}

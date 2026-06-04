{ inputs, ... }: {
  # HP 250 G9 — Intel laptop, Windows dual-boot, Steam + Sober for gaming.
  imports = [
    ../../modules/base.nix
    ../../modules/stylix.nix
    ../../modules/desktop/plasma6
    ../../modules/desktop/plasma6/autologin.nix
    ../../modules/hardware/laptop.nix
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    ../../modules/features/tailscale.nix
    ../../modules/features/dev-defaults.nix
    ../../modules/features/dualboot-grub.nix
    ../../modules/features/steam.nix
    ../../modules/features/flatpak.nix
  ];

  networking.hostName = "hp250";
  system.stateVersion = "25.11";

  # Dev override of the laptop default (which suspends on lid-close):
  # this machine stays on always.
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    IdleAction = "ignore";
  };

  services.flatpak.packages = [ "org.vinegarhq.Sober" ];
}

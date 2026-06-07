{ inputs, ... }: {
  # HP 250 G9 — Intel laptop, Windows dual-boot, Steam + Sober for gaming.
  imports = [
    ../common/optional/plasma6.nix
    ../common/optional/autologin.nix
    ../common/optional/hardware/laptop.nix
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    ../common/optional/tailscale.nix
    ../common/optional/dev-defaults.nix
    ../common/optional/dualboot-grub.nix
    ../common/optional/steam.nix
    ../common/optional/flatpak.nix
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

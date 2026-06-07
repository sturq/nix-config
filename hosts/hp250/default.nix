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

  # Intel watchdogs on Alder Lake don't release at shutdown — kernel logs
  # "watchdog did not stop!" and the reboot syscall hangs until the user
  # holds the power button. /sys/class/watchdog/watchdog0 on this box is
  # iTCO_wdt (not the OC variant), so blacklist that one. Drop both for
  # good measure; we don't need a hardware watchdog on a workstation.
  boot.blacklistedKernelModules = [ "intel_oc_wdt" "iTCO_wdt" ];

  services.flatpak.packages = [ "org.vinegarhq.Sober" ];
}

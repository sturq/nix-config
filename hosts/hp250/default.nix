{ inputs, lib, ... }: {
  # HP 250 G9 — Intel Alder Lake laptop. Thin wrapper: pulls the generic
  # laptop profile + intel-specific quirks + dualboot bootloader. Anything
  # truly HP-only (iTCO_wdt blacklist) lives here.
  imports = [
    ../laptop                                             # generic laptop profile
    ../common/optional/hardware/intel.nix                 # snd-intel-dspcfg quirk
    ../common/optional/boot/dualboot-grub.nix             # Windows + NixOS via GRUB
    ../common/optional/autologin.nix                      # skip SDDM greeter
    ../common/optional/apps/flatpak.nix                   # Sober (Roblox)
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
  ];

  networking.hostName = lib.mkForce "hp250";

  # iTCO + intel_oc watchdogs hang shutdown/reboot on this chassis.
  # Blacklist must persist — losing it = stuck on poweroff.
  boot.blacklistedKernelModules = [ "iTCO_wdt" "intel_oc_wdt" ];

  # Sober — Roblox via Vinegar's wrapper. Flatpak because it's not in
  # nixpkgs and the upstream wants a specific runtime.
  services.flatpak.packages = [ "org.vinegarhq.Sober" ];
}

# PLACEHOLDER hardware-configuration.nix
#
# Real values are generated on the target machine during the fresh install
# via `nixos-anywhere --generate-hardware-config nixos-generate-config ./hardware-configuration.nix`.
# This stub exists only so `nix flake check` evaluates on this repo.
{ lib, modulesPath, ... }: {
  boot.initrd.availableKernelModules = lib.mkDefault [ "nvme" "xhci_pci" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = lib.mkDefault [ ];
  boot.kernelModules = lib.mkDefault [ ];
  boot.extraModulePackages = lib.mkDefault [ ];

  fileSystems."/" = lib.mkDefault {
    device = "/dev/disk/by-label/PLACEHOLDER";
    fsType = "btrfs";
  };
  fileSystems."/boot" = lib.mkDefault {
    device = "/dev/disk/by-label/PLACEHOLDER-BOOT";
    fsType = "vfat";
  };

  swapDevices = lib.mkDefault [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}

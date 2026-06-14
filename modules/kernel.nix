{ pkgs, lib, ... }: {
  # Latest mainline kernel — best chance of supporting fresh hardware
  # (audio, GPUs, WiFi, peripherals) without per-host quirks.
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
}

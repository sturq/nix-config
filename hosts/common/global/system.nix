{ pkgs, lib, ... }: {
  # Defaults every NixOS host in this flake gets. Auto-imported by
  # mkHost. Stylix theming module is pulled in alongside this file.

  # ---- Boot + kernel ----------------------------------------------------
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
  };
  boot.loader.efi.canTouchEfiVariables = true;
  # Latest mainline kernel — best chance of supporting fresh hardware
  # (audio, GPUs, WiFi, peripherals) without per-host quirks.
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  # ---- Hardware enablement (generic, works on any x86_64) --------------
  # Pull in every redistributable firmware blob nixpkgs knows about
  # (Intel CPU microcode, AMD CPU microcode, NIC firmware, GPU
  # firmware, SOF audio firmware…). This is what the NixOS installer
  # ISO ships with.
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault true;
  hardware.cpu.amd.updateMicrocode   = lib.mkDefault true;
  hardware.graphics.enable = true;
  hardware.bluetooth.enable = true;

  # Trim SSDs weekly.
  services.fstrim.enable = true;

  # ---- Networking -------------------------------------------------------
  networking.networkmanager.enable = true;

  # ---- Timezone + locale -----------------------------------------------
  # Geo-located timezone (NetworkTime-style). en_GB so Qt6 renders the
  # 24h lockscreen clock + day-first dates without a per-host override.
  services.geoclue2.enable = true;
  services.automatic-timezoned.enable = true;
  i18n.defaultLocale = "en_GB.UTF-8";
  console.keyMap = "de";

  # ---- User -------------------------------------------------------------
  users.users.sturq = {
    isNormalUser = true;
    description = "sturq";
    extraGroups = [ "wheel" "networkmanager" ];
  };
  users.mutableUsers = true;

  # ---- Nix --------------------------------------------------------------
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # ---- Convention ------------------------------------------------------
  # Hosts must override system.stateVersion themselves.
}

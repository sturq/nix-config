{ lib, ... }: {
  # "I am a real Linux desktop." Firmware, generic hardware, networking,
  # locale, user, nix defaults. Every NixOS host wants all of this.
  # Boot loader + kernel are their own modules.

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault true;
  hardware.cpu.amd.updateMicrocode   = lib.mkDefault true;
  hardware.graphics.enable = true;
  hardware.bluetooth.enable = true;
  services.fstrim.enable = true;

  networking.networkmanager.enable = true;

  services.geoclue2.enable = true;
  services.automatic-timezoned.enable = true;
  i18n.defaultLocale = "en_GB.UTF-8";
  console.keyMap = "de";

  users.users.sturq = {
    isNormalUser = true;
    description = "sturq";
    extraGroups = [ "wheel" "networkmanager" ];
  };
  users.mutableUsers = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
}

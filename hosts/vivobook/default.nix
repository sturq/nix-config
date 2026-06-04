{ ... }: {
  # ASUS Vivobook S 14 M5406WA — AMD Strix Point laptop.
  imports = [
    ../../modules/profiles/laptop.nix
    ../../modules/amd-laptop.nix         # asusd, amd_pstate, charge limit
  ];

  networking.hostName = "vivobook";

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 3;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
}

{ config, pkgs, lib, ... }: {
  # Boot loader: every host gets systemd-boot unless overridden.
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  # Networking
  networking.networkmanager.enable = true;

  # Locale (sturq is in Vienna)
  time.timeZone = "Europe/Vienna";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "de";

  # User (declarative)
  # Hosts override `hashedPasswordFile` or `initialPassword` as needed.
  users.users.sturq = {
    isNormalUser = true;
    description = "sturq";
    extraGroups = [ "wheel" "networkmanager" ];
  };
  users.mutableUsers = true;

  # Nix settings: flakes + nix-command everywhere
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  # ventoy-full is flagged insecure (bundles old WebKit upstream).
  nixpkgs.config.permittedInsecurePackages = [ "ventoy-1.1.12" ];

  # dconf needed for any host with home-manager dconf.settings
  programs.dconf.enable = true;

  # Hosts must override system.stateVersion themselves
}

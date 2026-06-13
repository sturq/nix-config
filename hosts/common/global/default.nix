{ config, pkgs, lib, ... }: {
  # Defaults every NixOS host in this flake gets. Auto-imported by every
  # mkHost call in flake.nix — no host has to ask for the boot loader,
  # the sturq user, timezone auto-detection or the en_GB locale.
  imports = [
    ./stylix.nix
  ];

  # Boot loader: every host gets systemd-boot unless overridden.
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  # Networking
  networking.networkmanager.enable = true;

  # Auto-detect timezone via GeoClue (no hardcoded Europe/Vienna). The
  # NixOS installer / Anaconda / GNOME / Ubuntu Network Time pattern —
  # automatic-timezoned + geoclue2 watch the IP geo-location and feed
  # the result to systemd-timedated. Travelling between countries just
  # works, fresh installs don't need a per-host override.
  services.geoclue2.enable = true;
  services.automatic-timezoned.enable = true;

  # English UI + 24h clock. en_GB gives Qt6 the 24h hint the kscreenlocker
  # greeter needs (LC_TIME alone isn't enough — Qt only reads LANG for
  # QLocale defaults). Day-first dates fall out for free.
  i18n.defaultLocale = "en_GB.UTF-8";
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

  # Hosts must override system.stateVersion themselves
}

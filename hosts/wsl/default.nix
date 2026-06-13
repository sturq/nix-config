{ ... }: {
  # NixOS-WSL host: runs inside Windows Subsystem for Linux 2.
  # No boot loader (Windows boots), no display manager, mostly CLI.

  wsl = {
    enable = true;
    defaultUser = "sturq";
    # Friendly hostname inside WSL
    wslConf.network.hostname = "wsl";
    # Don't shoot yourself: keep Windows interop
    interop.includePath = false;  # avoid PATH pollution with Windows binaries
  };

  networking.hostName = "wsl";

  # WSL2 already has its own root user. Add yourself with sudo access.
  users.users.sturq = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  # WSL skips hosts/common/global (boot loader, networkmanager etc don't
  # apply inside WSL) — replicate just the bits that do.
  time.timeZone = "Europe/Vienna";
  i18n.defaultLocale = "en_GB.UTF-8";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.11";
}

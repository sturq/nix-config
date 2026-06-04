{ ... }: {
  # Shared "any workstation" baseline — used by both the laptop and the
  # desktop profile. KDE Plasma 6 (Wayland) + SDDM, Stylix theming, Tailscale,
  # SSH on, dev passwords. No hardware-specific knobs in here.
  imports = [
    ../base.nix
    ../plasma6
    ../stylix.nix
    ../tailscale.nix
  ];

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
    settings.PermitRootLogin = "yes";
  };

  users.users.sturq.initialPassword = "install";
  users.users.root.initialPassword = "install";

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.11";
}

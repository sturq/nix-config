{ ... }: {
  # Declarative Flatpak via nix-flatpak. Enable on hosts that need
  # apps not packaged in nixpkgs (Sober for Roblox, etc.) — set
  # services.flatpak.packages on the host.
  services.flatpak.enable = true;
}

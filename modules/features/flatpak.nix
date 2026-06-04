{ ... }: {
  # Generic Flatpak support via nix-flatpak. Hosts add their own
  # services.flatpak.packages list (e.g. [ "org.vinegarhq.Sober" ]).
  services.flatpak.enable = true;
}

{ ... }: {
  # Sober (Vinegar's Roblox wrapper) — declarative via nix-flatpak,
  # which needs the flatpak.nix module in this folder enabled too
  # and the nix-flatpak NixOS module pulled into the host.
  services.flatpak.packages = [ "org.vinegarhq.Sober" ];
}

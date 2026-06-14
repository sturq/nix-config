{ ... }: {
  # Imported by every "real" NixOS host (laptop + desktop). WSL skips
  # this — see hosts/wsl/default.nix, which sets only the bits that
  # apply inside WSL2.
  imports = [
    ./system.nix
    ./dev-defaults.nix
    ./stylix.nix
  ];
}

{ ... }: {
  # Applications layer. Per-host opt-in — hosts pick which apps they
  # want. Steam + Sober are heavy / not universal; keepassxc is
  # genuinely "always want" so it's in the auto-import list below.
  imports = [
    ./keepassxc.nix
    # ./flatpak.nix         # opt-in per host
    # ./sober.nix           # opt-in per host (requires flatpak.nix)
    # ./steam.nix           # opt-in per host
  ];
}

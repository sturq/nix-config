{ pkgs, ... }: {
  # Nix-specific tooling.
  home.packages = with pkgs; [
    nh                 # friendlier nixos-rebuild wrapper
    nix-output-monitor # nicer build output
    nix-tree           # explore /nix/store visually
    alejandra          # Nix formatter
    statix             # Nix linter
    deadnix            # Nix dead-code finder
  ];
}

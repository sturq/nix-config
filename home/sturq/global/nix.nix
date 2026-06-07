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

  # direnv + nix-direnv: auto-load shell.nix / flake.nix devshells when
  # cd'ing into a project. Lives here because nix-direnv is the reason
  # we care about direnv at all.
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}

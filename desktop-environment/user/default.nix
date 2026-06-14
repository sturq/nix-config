{ ... }: {
  # KDE Plasma 6 user-side. Each concern its own file.
  imports = [
    ./theme.nix
    ./panel.nix
    ./shortcuts.nix
    ./session.nix
    ./konsole.nix
    ./compositor.nix
  ];

  programs.plasma.enable = true;
}

{ pkgs, ... }: {
  # KDE Plasma 6 (user-level). Theme + panel + shortcuts + session split
  # across siblings so each file is a single concern. Konsole keeps its
  # own file because the colourscheme generation has no overlap with the
  # plasma-manager surface.
  imports = [
    ./theme.nix
    ./panel.nix
    ./shortcuts.nix
    ./session.nix
    ./konsole.nix
    ./perf.nix
  ];

  programs.plasma.enable = true;

  home.packages = with pkgs; [
    keepassxc
  ];
}

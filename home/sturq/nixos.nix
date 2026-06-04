{ ... }: {
  # Full Linux desktop — CLI + KDE Plasma 6 (Wayland).
  imports = [
    ../features/cli
    ../features/plasma6
  ];

  home.username = "sturq";
  home.homeDirectory = "/home/sturq";
}

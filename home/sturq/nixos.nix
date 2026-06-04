{ ... }: {
  # Full Linux desktop — CLI + KDE Plasma 6 (Wayland).
  imports = [
    ../features/cli
    ../features/desktop
  ];

  home.username = "sturq";
  home.homeDirectory = "/home/sturq";
}

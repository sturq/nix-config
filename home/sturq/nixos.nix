{ ... }: {
  # Full Linux desktop — CLI + KDE Plasma 6 (Wayland).
  imports = [
    ./common/global
    ./common/optional/desktop/plasma
  ];

  home.username = "sturq";
  home.homeDirectory = "/home/sturq";
}

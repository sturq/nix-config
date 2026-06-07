{ ... }: {
  # Full Linux desktop — CLI + KDE Plasma 6 (Wayland).
  imports = [
    ./global
    ./optional/plasma6
    ./optional/steam.nix
  ];

  home.username = "sturq";
  home.homeDirectory = "/home/sturq";
}

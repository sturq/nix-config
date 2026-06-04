{ ... }: {
  # Full Linux desktop — CLI + dwl (Wayland, suckless-style).
  imports = [
    ../features/cli
    ../features/desktop
  ];

  home.username = "sturq";
  home.homeDirectory = "/home/sturq";
}

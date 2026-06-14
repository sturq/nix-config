{ ... }: {
  # WSL = CLI only, no Plasma desktop.
  imports = [
    ./features/cli
  ];

  home.username = "sturq";
  home.homeDirectory = "/home/sturq";
}

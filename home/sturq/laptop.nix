{ ... }: {
  # Per-(user, host) entrypoint. Laptop = CLI + full Plasma desktop.
  imports = [
    ./features/cli
    ./features/desktop
  ];

  home.username = "sturq";
  home.homeDirectory = "/home/sturq";
}

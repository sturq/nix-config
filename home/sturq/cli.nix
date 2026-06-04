{ ... }: {
  # CLI-only — for WSL, servers, headless boxes.
  imports = [ ../features/cli ];

  home.username = "sturq";
  home.homeDirectory = "/home/sturq";
}

{ ... }: {
  # CLI-only — for WSL, servers, headless boxes.
  imports = [ ./global ];

  home.username = "sturq";
  home.homeDirectory = "/home/sturq";
}

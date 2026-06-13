{ ... }: {
  # CLI-only — for WSL, servers, headless boxes.
  imports = [ ./common/global ];

  home.username = "sturq";
  home.homeDirectory = "/home/sturq";
}

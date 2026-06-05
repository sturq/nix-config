{ ... }: {
  # CLI-only — for WSL, servers, headless boxes.
  imports = [ ../../modules/home/cli ];

  home.username = "sturq";
  home.homeDirectory = "/home/sturq";
}

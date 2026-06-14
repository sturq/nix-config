{ ... }: {
  # Bare-bones user env: only what you can't function without. Add
  # shell.nix / git.nix / ssh.nix / nix.nix etc. back as siblings here
  # when you decide you actually want them.
  imports = [
    ./tools.nix
    ./git.nix
    ./shell.nix
  ];

  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
}

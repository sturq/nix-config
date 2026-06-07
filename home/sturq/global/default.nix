{ ... }: {
  imports = [
    ./shell.nix
    ./git.nix
    ./ssh.nix
    ./tools.nix
    ./nix.nix
  ];

  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
}

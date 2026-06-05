{ ... }: {
  imports = [
    ./shell.nix
    ./git.nix
    ./ssh.nix
    ./direnv.nix
    ./tools.nix
    ./nix.nix
    ./claude-code.nix
  ];

  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
}

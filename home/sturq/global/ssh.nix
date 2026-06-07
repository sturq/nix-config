{ pkgs, ... }: {
  home.packages = with pkgs; [ openssh mosh ];

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
      };
    };
  };
}

{ pkgs, ... }: {
  programs.git = {
    enable = true;
    userName = "sturq";
    userEmail = "sturq@users.noreply.github.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
  };

  programs.gh.enable = true;
}

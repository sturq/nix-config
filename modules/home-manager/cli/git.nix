{ ... }: {
  programs.git = {
    enable = true;
    settings = {
      user.name = "sturq";
      user.email = "sturq@users.noreply.github.com";
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
  };

  programs.gh.enable = true;
}

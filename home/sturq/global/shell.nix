{ pkgs, ... }: {
  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "eza -l --git";
      la = "eza -la --git";
      lt = "eza --tree --level=2";
      cat = "bat";
      grep = "rg";
      ".." = "cd ..";
      "..." = "cd ../..";
    };
  };

  programs.starship = {
    enable = true;
    settings.add_newline = false;
  };

  programs.fzf.enable = true;
  programs.tmux.enable = true;
}

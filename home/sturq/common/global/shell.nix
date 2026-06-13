{ ... }: {
  # Bash with a periwinkle lambda prompt. λ stands in for both PS1's $
  # and the "I/me" identity — same lambda as the kickoff icon and the
  # sturq.github.io logo.
  programs.bash = {
    enable = true;
    historyControl = [ "ignoredups" "ignorespace" ];
    shellAliases = {
      ll = "ls -lah";
      gs = "git status";
    };

    # 24-bit periwinkle (#B9C5EE) lambda, dim cwd, single-space prompt.
    initExtra = ''
      PS1='\[\e[1;38;2;185;197;238m\]λ\[\e[0m\] \[\e[2m\]\w\[\e[0m\] '
    '';

    # Greeting banner on interactive login.
    bashrcExtra = ''
      if [ -n "$PS1" ] && [ -t 1 ]; then
        printf '\e[38;2;185;197;238mλ\e[0m sturq\n'
      fi
    '';
  };
}

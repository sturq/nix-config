{ palette, ... }:

let
  primaryRgb = palette.hexToRgb palette.core.primary;
in {
  # Bash with a periwinkle lambda prompt. λ stands in for both PS1's $
  # and the "I/me" identity — same lambda as the kickoff icon and the
  # sturq.github.io logo. Colour pulled from palette so it tracks any
  # palette swap automatically.
  programs.bash = {
    enable = true;
    historyControl = [ "ignoredups" "ignorespace" ];
    shellAliases = {
      ll = "ls -lah";
      gs = "git status";
    };

    initExtra = ''
      PS1='\[\e[1;38;2;${primaryRgb}m\]λ\[\e[0m\] \[\e[2m\]\w\[\e[0m\] '
    '';

    bashrcExtra = ''
      if [ -n "$PS1" ] && [ -t 1 ]; then
        printf '\e[38;2;${primaryRgb}mλ\e[0m sturq\n'
      fi
    '';
  };
}

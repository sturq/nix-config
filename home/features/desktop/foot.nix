{ lib, ... }: {
  # foot terminal — OLED-black bg + Termux/Tango ANSI colors.
  # Stylix would otherwise theme foot with sturq-palette; we override here.
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "monospace:size=12";
        pad = "8x8";
      };
      colors = lib.mkForce {
        alpha = "1.0";
        background = "000000";
        foreground = "ffffff";

        # Standard Tango palette — same as default Termux.
        regular0 = "000000";  # black
        regular1 = "cc0000";  # red
        regular2 = "4e9a06";  # green
        regular3 = "c4a000";  # yellow
        regular4 = "3465a4";  # blue
        regular5 = "75507b";  # magenta
        regular6 = "06989a";  # cyan
        regular7 = "d3d7cf";  # white

        bright0 = "555753";   # bright black
        bright1 = "ef2929";   # bright red
        bright2 = "8ae234";   # bright green
        bright3 = "fce94f";   # bright yellow
        bright4 = "729fcf";   # bright blue
        bright5 = "ad7fa8";   # bright magenta
        bright6 = "34e2e2";   # bright cyan
        bright7 = "eeeeec";   # bright white
      };
    };
  };
}

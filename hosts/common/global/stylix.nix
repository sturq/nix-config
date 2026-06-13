{ pkgs, inputs, ... }:

let
  palette = import ../../../lib/palette.nix { src = inputs.sturq-palette; };
in {
  stylix = {
    enable = true;
    polarity = "dark";
    base16Scheme = palette.base16Scheme;

    image = pkgs.runCommand "wallpaper.png" {
      buildInputs = [ pkgs.imagemagick ];
    } ''
      cat > lambda.svg <<'EOF'
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 120">
        <polygon points="32,0 48,0 95,120 79,120 58,65 22,120 4,120 51,48"
                 fill="${palette.core.primary}"/>
      </svg>
      EOF
      magick -background none -size 600x720 lambda.svg lambda.png
      magick -size 1920x1080 xc:'${palette.core.base}' \
        lambda.png -gravity SouthEast -geometry -100-80 -composite \
        $out
    '';

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    fonts = {
      monospace = { package = pkgs.dejavu_fonts; name = "DejaVu Sans Mono"; };
      sansSerif = { package = pkgs.dejavu_fonts; name = "DejaVu Sans";      };
      serif     = { package = pkgs.dejavu_fonts; name = "DejaVu Serif";     };
      sizes = {
        applications = 11;
        terminal     = 12;
        desktop      = 11;
        popups       = 11;
      };
    };

    opacity.terminal = 0.95;
    targets.kmscon.enable = false;
  };

  console = {
    earlySetup = true;
    colors = with palette.base16Scheme; [
      base00 base08 base0B base0A base0D base0E base0C base05
      base03 base08 base0B base0A base0D base0E base0C base07
    ];
  };

  # Keep KDE's stock Breeze look — Stylix tinting every colour slot
  # was too much, windows ended up not matching anything else. Only
  # the accent (kdeglobals.General.AccentColor) is overridden, set
  # explicitly in home/sturq/common/optional/desktop/plasma/theme.nix
  # against palette.core.primary.
  home-manager.sharedModules = [{
    stylix.targets.kde.enable = false;
    stylix.targets.qt.enable = false;
  }];
}

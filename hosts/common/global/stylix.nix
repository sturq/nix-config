{ pkgs, inputs, ... }:

let
  palette = import ../../../lib/palette.nix { src = inputs.sturq-palette; };
in {
  stylix = {
    enable = true;
    polarity = "dark";
    base16Scheme = palette.base16Scheme;

    # Wallpaper: sturq.github.io body recipe ported 1:1 from the CSS
    #   body { background:
    #     radial-gradient(ellipse 90% 50% at 50% 0%, rgba(185,197,238,0.08) 0%, transparent 60%),
    #     radial-gradient(ellipse 80% 40% at 50% 100%, rgba(64,70,97,0.5) 0%, transparent 70%),
    #     var(--bg);
    #   }
    # — alpha values are the exact site values (0x14 = 0.08, 0x80 = 0.5).
    # Blur sigma tightened so the base #2A3042 still dominates the
    # middle (previous attempt washed out). Λ accent bottom-right.
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

      magick -size 1920x1080 xc:none \
        -fill '#B9C5EE14' \
        -draw 'ellipse 960,0 864,270 0,360' \
        -blur 0x30 \
        top-glow.png

      magick -size 1920x1080 xc:none \
        -fill '#40466180' \
        -draw 'ellipse 960,1080 768,216 0,360' \
        -blur 0x30 \
        bottom-glow.png

      magick -size 1920x1080 xc:'${palette.core.base}' \
        top-glow.png -composite \
        bottom-glow.png -composite \
        lambda.png -gravity SouthEast -geometry -100-80 -composite \
        $out
    '';

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    # Fonts ported from the site's CSS custom properties:
    #   --display-font: "Cormorant" serif       — hero titles, blockquotes
    #   --mono-font:    "JetBrains Mono"        — code + UI labels
    #   --ui-font:      system-ui sans-serif    — body text (DejaVu sans = close)
    fonts = {
      monospace = { package = pkgs.jetbrains-mono; name = "JetBrains Mono"; };
      sansSerif = { package = pkgs.dejavu_fonts;   name = "DejaVu Sans";    };
      serif     = { package = pkgs.cormorant;      name = "Cormorant";     };
      sizes = {
        applications = 11;
        terminal     = 12;
        desktop      = 11;
        popups       = 11;
      };
    };

    opacity = {
      terminal = 0.92;
      desktop  = 0.78;   # panel + plasma surfaces — let KWin Blur show through
      popups   = 0.85;   # menus / kickoff / notifications — frosted glass
    };
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

{ pkgs, lib, ... }:

let
  palette = lib.palette;

  # Wallpaper: solid palette base + Λ accent bottom-right.
  wallpaperImage = pkgs.runCommand "wallpaper.png" {
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
in {
  programs.plasma = {
    # BreezeDark colour-scheme only. lookAndFeel left to Plasma's own
    # modern default — Breeze's lookAndFeel forced an older opaque
    # panel theme that defeated KWin Blur, the default lookAndFeel
    # ships a translucent panel SVG that actually lets Blur work.
    workspace = {
      colorScheme = "BreezeDark";
      wallpaper   = "${wallpaperImage}";
      cursor      = { theme = "Bibata-Modern-Classic"; size = 24; };
    };

    configFile = {
      # Fonts + the one colour key Stylix doesn't reliably re-inject
      # after a panel reset: AccentColor. Without this Plasma falls
      # back to Breeze blue, breaking the palette unity.
      # Font choices match the site CSS:
      #   --ui-font   → DejaVu Sans (close to system-ui)
      #   --mono-font → JetBrains Mono (`fixed`)
      #   AccentColor → palette periwinkle (site --accent)
      kdeglobals."General" = {
        AccentColor          = palette.hexToRgb palette.core.primary;
        font                 = "DejaVu Sans,11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
        menuFont             = "DejaVu Sans,11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
        toolBarFont          = "DejaVu Sans,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
        smallestReadableFont = "DejaVu Sans,9,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
        fixed                = "JetBrains Mono,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,0";
      };
      kdeglobals."KDE" = {
        SingleClick = false;
        AnimationDurationFactor = 0.5;
      };
      kdeglobals."WM"."activeFont" = "DejaVu Sans,11,-1,5,500,0,0,0,0,0,0,0,0,0,0,1";

      # Plasma exports LANG from this file into the session env at login;
      # a stale en_US entry left over from System Settings was making the
      # lockscreen greeter render 12h despite the system locale being en_GB.
      plasma-localerc.Formats = {
        LANG = "en_GB.UTF-8";
        useDetailed = true;
      };
    };
  };

  # Stale Win11-style Meta+Down shortcut sweep — plasma-manager only
  # adds/updates keys, never deletes them.
  home.activation.cleanStaleShortcuts =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 \
        --file "$HOME/.config/kglobalshortcutsrc" \
        --group "kwin" --key "Win11-style Meta+Down (tile / minimise)" --delete
      run ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 \
        --file "$HOME/.config/kglobalshortcutsrc" \
        --group "kwin" --key "win11-meta-down" --delete
      run rm -f "$HOME/.config/kglobalshortcutsrc.lock"
    '';
}

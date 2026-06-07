{ pkgs, inputs, lib, ... }:

let
  palette = import ../../../../lib/palette.nix { src = inputs.sturq-palette; };
  rgb = palette.hexToRgb;
  accentRgb = rgb palette.roles.accent;

  # plasma-manager owns the wallpaper because Stylix's KDE target forced a
  # light scheme on us before; the solid PNG goes through workspace.wallpaper.
  wallpaperImage = pkgs.runCommand "wallpaper.png" {
    buildInputs = [ pkgs.imagemagick ];
  } "magick -size 1920x1080 xc:'${palette.roles.wallpaper}' $out";
in {
  programs.plasma = {
    workspace = {
      colorScheme = "BreezeDark";
      lookAndFeel = "org.kde.breezedark.desktop";
      iconTheme   = "Papirus-Dark";
      wallpaper   = "${wallpaperImage}";
      cursor = { theme = "Bibata-Modern-Classic"; size = 24; };
    };

    configFile = {
      kdeglobals."General" = {
        AccentColor          = rgb palette.roles.accent;
        font                 = "Roboto Flex,11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
        menuFont             = "Roboto Flex,11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
        toolBarFont          = "Roboto Flex,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
        smallestReadableFont = "Roboto Flex,9,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
        fixed                = "DejaVu Sans Mono,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,0";
      };
      kdeglobals."KDE" = {
        SingleClick = false;
        AnimationDurationFactor = 0.5;
      };
      kdeglobals."WM"."activeFont" = "Roboto Flex,11,-1,5,500,0,0,0,0,0,0,0,0,0,0,1";

      # (Stylix leaves [Colors:Header][Inactive] on Plasma's default blue.
      # Fixed via home.activation below — plasma-manager's INI writer
      # escapes the second pair of brackets into \x5d\x5b, creating a
      # broken section name instead of KDE's multi-group syntax.)

      # Plasma exports LANG from this file into the session env at login;
      # a stale en_US entry left over from System Settings was making the
      # lockscreen greeter render 12h despite the system locale being en_GB.
      plasma-localerc.Formats = {
        LANG = "en_GB.UTF-8";
        useDetailed = true;
      };
    };
  };

  # Force lavender into [Colors:Header][Inactive] (Stylix leaves it on
  # Plasma's default blue). plasma-manager's INI writer can't express
  # KDE's multi-group bracket syntax, so we patch via kwriteconfig6
  # which handles --group ... --group ... natively.
  home.activation.fixHeaderInactiveAccent =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 \
        --file "$HOME/.config/kdeglobals" \
        --group "Colors:Header" --group "Inactive" \
        --key DecorationFocus "${accentRgb}"
      run ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 \
        --file "$HOME/.config/kdeglobals" \
        --group "Colors:Header" --group "Inactive" \
        --key DecorationHover "${accentRgb}"
      run ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 \
        --file "$HOME/.config/kdeglobals" \
        --group "Colors:Header" --group "Inactive" \
        --key ForegroundActive "${accentRgb}"

      # Clean up the stale Win11-style Meta+Down entry from when we ran
      # the chained KWin script. plasma-manager only adds/updates keys,
      # never deletes them, so we sweep the leftover binding ourselves.
      run ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 \
        --file "$HOME/.config/kglobalshortcutsrc" \
        --group "kwin" --key "Win11-style Meta+Down (tile / minimise)" --delete
      run ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 \
        --file "$HOME/.config/kglobalshortcutsrc" \
        --group "kwin" --key "win11-meta-down" --delete
      run rm -f "$HOME/.config/kglobalshortcutsrc.lock"
    '';
}

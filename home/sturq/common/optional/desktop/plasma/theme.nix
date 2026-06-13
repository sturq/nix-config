{ pkgs, inputs, lib, ... }:

let
  palette = import ../../../../../../lib/palette.nix { src = inputs.sturq-palette; };

  # Wallpaper: radial gradient mimicking sturq.github.io's body
  # background — lighter near top-centre (#353B50, site --surface-0)
  # fading to the deep OLED step (#1F2333, --bg-deep) at the edges.
  wallpaperImage = pkgs.runCommand "wallpaper.png" {
    buildInputs = [ pkgs.imagemagick ];
  } ''
    magick -size 1920x1080 radial-gradient:'#353B50'-'#1F2333' $out
  '';
in {
  programs.plasma = {
    # Don't set workspace.colorScheme — stylix.targets.kde.enable=true
    # generates a "Stylix" colorscheme from the base16 palette and sets
    # it as default. Forcing BreezeDark here would overwrite that.
    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop"; # structural only
      wallpaper   = "${wallpaperImage}";
      cursor      = { theme = "Bibata-Modern-Classic"; size = 24; };
    };

    configFile = {
      # Fonts only — colour-related keys (AccentColor etc.) are owned
      # by stylix so KDE pulls everything from the palette.
      kdeglobals."General" = {
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

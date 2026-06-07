{ pkgs, inputs, ... }:

let
  palette = import ../../../../lib/palette.nix { src = inputs.sturq-palette; };
  rgb = palette.hexToRgb;

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
      iconTheme   = "Tela-circle-dark";
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

      # Plasma exports LANG from this file into the session env at login;
      # a stale en_US entry left over from System Settings was making the
      # lockscreen greeter render 12h despite the system locale being en_GB.
      plasma-localerc.Formats = {
        LANG = "en_GB.UTF-8";
        useDetailed = true;
      };
    };
  };
}

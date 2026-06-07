{ pkgs, inputs, ... }:

let
  palette = import ../../lib/palette.nix { src = inputs.sturq-palette; };

  # A role names a UI surface; the value names which palette token paints it.
  # Roles fall back to base16 slots when the source palette doesn't ship the
  # extended JSON tree, so any palette repo works without further wiring.
  pickToken = jsonPath: slot:
    if palette.palette != null && jsonPath != null
    then jsonPath
    else "#${palette.base16Scheme.${slot}}";

  roles = {
    wallpaper = pickToken
      (if palette.palette != null then palette.palette.surfaces.surface0 else null)
      "base02";

    # Lockscreen stays pure black regardless of palette.
    lockscreen = "#000000";
  };
in {
  stylix = {
    enable = true;
    polarity = "dark";
    base16Scheme = palette.base16Scheme;

    image = pkgs.runCommand "wallpaper.png" {
      buildInputs = [ pkgs.imagemagick ];
    } "magick -size 1920x1080 xc:'${roles.wallpaper}' $out";

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

  home-manager.sharedModules = [
    { stylix.targets.kde.enable = true; }
  ];
}

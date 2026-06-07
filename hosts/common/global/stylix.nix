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
    } "magick -size 1920x1080 xc:'${palette.roles.wallpaper}' $out";

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

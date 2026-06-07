{ pkgs, inputs, ... }:

let
  palette = import ../../../lib/palette.nix { src = inputs.sturq-palette; };

  rgb = key: palette.hexToRgb "#${palette.base16Scheme.${key}}";

  colorscheme = pkgs.writeText "palette.colorscheme" ''
    [Background]
    Color=${rgb "base00"}

    [BackgroundIntense]
    Color=${rgb "base00"}

    [BackgroundFaint]
    Color=${rgb "base00"}

    [Foreground]
    Color=${rgb "base05"}

    [ForegroundIntense]
    Color=${rgb "base06"}

    [ForegroundFaint]
    Color=${rgb "base04"}

    [Color0]
    Color=${rgb "base01"}
    [Color1]
    Color=${rgb "base08"}
    [Color2]
    Color=${rgb "base0B"}
    [Color3]
    Color=${rgb "base0A"}
    [Color4]
    Color=${rgb "base0D"}
    [Color5]
    Color=${rgb "base0E"}
    [Color6]
    Color=${rgb "base0C"}
    [Color7]
    Color=${rgb "base05"}

    [Color0Intense]
    Color=${rgb "base03"}
    [Color1Intense]
    Color=${rgb "base08"}
    [Color2Intense]
    Color=${rgb "base0B"}
    [Color3Intense]
    Color=${rgb "base0A"}
    [Color4Intense]
    Color=${rgb "base0D"}
    [Color5Intense]
    Color=${rgb "base0E"}
    [Color6Intense]
    Color=${rgb "base0C"}
    [Color7Intense]
    Color=${rgb "base07"}

    [General]
    Blur=false
    ColorRandomization=false
    Description=palette
    Opacity=1
    Wallpaper=
  '';

  profile = pkgs.writeText "palette.profile" ''
    [Appearance]
    ColorScheme=palette
    Font=DejaVu Sans Mono,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,1

    [General]
    Name=palette
    Parent=FALLBACK/
  '';
in {
  home.file.".local/share/konsole/palette.colorscheme".source = colorscheme;
  home.file.".local/share/konsole/palette.profile".source     = profile;

  xdg.configFile."konsolerc".text = ''
    [Desktop Entry]
    DefaultProfile=palette.profile

    [General]
    ConfigVersion=1
  '';
}

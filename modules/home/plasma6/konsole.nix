{ pkgs, lib, inputs, ... }: let
  sp  = import ../../../lib/palette.nix { src = inputs.sturq-palette; };
  b16 = sp.base16Scheme;
  rgb = hex: sp.hexToRgb "#${hex}";

  # Konsole expects R,G,B per slot. base16 → ANSI ramp:
  #   base08 = red       base0A = yellow    base0C = cyan
  #   base09 = orange    base0B = green     base0D = blue    base0E = magenta
  scheme = pkgs.writeText "sturq.colorscheme" ''
    [Background]
    Color=${rgb b16.base00}

    [BackgroundIntense]
    Color=${rgb b16.base00}

    [BackgroundFaint]
    Color=${rgb b16.base00}

    [Foreground]
    Color=${rgb b16.base05}

    [ForegroundIntense]
    Color=${rgb b16.base06}

    [ForegroundFaint]
    Color=${rgb b16.base04}

    [Color0]
    Color=${rgb b16.base01}
    [Color1]
    Color=${rgb b16.base08}
    [Color2]
    Color=${rgb b16.base0B}
    [Color3]
    Color=${rgb b16.base0A}
    [Color4]
    Color=${rgb b16.base0D}
    [Color5]
    Color=${rgb b16.base0E}
    [Color6]
    Color=${rgb b16.base0C}
    [Color7]
    Color=${rgb b16.base05}

    [Color0Intense]
    Color=${rgb b16.base03}
    [Color1Intense]
    Color=${rgb b16.base08}
    [Color2Intense]
    Color=${rgb b16.base0B}
    [Color3Intense]
    Color=${rgb b16.base0A}
    [Color4Intense]
    Color=${rgb b16.base0D}
    [Color5Intense]
    Color=${rgb b16.base0E}
    [Color6Intense]
    Color=${rgb b16.base0C}
    [Color7Intense]
    Color=${rgb b16.base07}

    [General]
    Blur=false
    ColorRandomization=false
    Description=sturq palette
    Opacity=1
    Wallpaper=
  '';

  profile = pkgs.writeText "sturq.profile" ''
    [Appearance]
    ColorScheme=sturq
    Font=DejaVu Sans Mono,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,1

    [General]
    Name=sturq
    Parent=FALLBACK/
  '';
in {
  # Drop both the colourscheme and a default profile into ~/.local/share/konsole/
  # so every new Konsole window uses the palette ANSI ramp out of the box.
  home.file.".local/share/konsole/sturq.colorscheme".source = scheme;
  home.file.".local/share/konsole/sturq.profile".source     = profile;

  # Point konsolerc at our profile as the default.
  xdg.configFile."konsolerc".text = ''
    [Desktop Entry]
    DefaultProfile=sturq.profile

    [General]
    ConfigVersion=1
  '';
}

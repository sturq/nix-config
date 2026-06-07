# Parse the sturq-palette JSON repo into Nix attrs, build the base16 scheme,
# and expose a small hex→RGB helper for KDE configs.
#
# Usage:
#   inputs.sturq-palette = { url = "github:sturq/sturq-palette"; flake = false; };
#   let palette = import ./lib/palette.nix { src = inputs.sturq-palette; };
#   in palette.palette.core.primary  # "#B9C5EE"
#      palette.base16Scheme          # { base00 = "000000"; ... }
#      palette.hexToRgb "#0000EE"    # "0,0,238"
{ src }: let
  palette = builtins.fromJSON (builtins.readFile "${src}/formats/palette.json");

  stripHash = s: builtins.substring 1 (builtins.stringLength s - 1) s;

  base16Scheme = builtins.mapAttrs (_: stripHash) {
    base00 = palette.surfaces.crust;
    base01 = palette.surfaces.base;
    base02 = palette.surfaces.surface0;
    base03 = "#7F7F7F";
    base04 = palette.text.overlay2;
    base05 = palette.text.text;
    base06 = palette.text.subtext1;
    base07 = palette.text.subtext0;
    base08 = palette.accents.red;
    base09 = palette.accents.orange;
    base0A = palette.accents.yellow;
    base0B = palette.accents.green;
    base0C = palette.accents.cyan;
    base0D = palette.accents.blue;
    base0E = palette.accents.magenta;
    base0F = palette.accents.maroon;
  };

  hexToRgb = hex: let
    s = builtins.substring 1 6 hex;
    h2d = c: let
      m = { "0"=0; "1"=1; "2"=2; "3"=3; "4"=4; "5"=5; "6"=6; "7"=7; "8"=8; "9"=9;
            "a"=10; "b"=11; "c"=12; "d"=13; "e"=14; "f"=15;
            "A"=10; "B"=11; "C"=12; "D"=13; "E"=14; "F"=15; };
    in m.${c};
    byte = i: 16 * (h2d (builtins.substring i 1 s)) + (h2d (builtins.substring (i+1) 1 s));
  in "${toString (byte 0)},${toString (byte 2)},${toString (byte 4)}";
in {
  inherit palette base16Scheme hexToRgb stripHash;
}

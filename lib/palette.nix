{ src }:

# Parse a structured palette repo (formats/palette.json) and expose:
#
#   core        { base; primary; }
#   surfaces    { crust; mantle; dim; surface0; surface1; surface2; }
#   text        { text; subtext1; subtext0; overlay2; overlay1; overlay0; }
#   accents     { red; orange; yellow; green; cyan; blue; magenta; maroon;
#                 bright = { ... }; }
#   roles       { accent; wallpaper; lockscreen; }   # named UI surfaces
#   base16Scheme   {base00..base0F} bare hex (no '#'), for Stylix
#   hexToRgb       "#RRGGBB" -> "r,g,b"
#   stripHash      "#rrggbb" -> "rrggbb"
#
# Drop in any palette that ships formats/palette.json with the sturq
# token tree (see sturq/sturq-palette for the shape).

let
  inherit (builtins) fromJSON mapAttrs readFile stringLength substring;

  stripHash = s: substring 1 (stringLength s - 1) s;

  hexToRgb = hex:
    let
      digit = c: {
        "0"=0; "1"=1; "2"=2; "3"=3; "4"=4; "5"=5; "6"=6; "7"=7;
        "8"=8; "9"=9;
        "a"=10; "b"=11; "c"=12; "d"=13; "e"=14; "f"=15;
        "A"=10; "B"=11; "C"=12; "D"=13; "E"=14; "F"=15;
      }.${c};
      body = substring 1 6 hex;
      byte = i:
        16 * (digit (substring i 1 body))
        +     digit (substring (i + 1) 1 body);
    in "${toString (byte 0)},${toString (byte 2)},${toString (byte 4)}";

  json = fromJSON (readFile "${src}/formats/palette.json");

  base16Scheme = mapAttrs (_: stripHash) {
    base00 = json.surfaces.crust;
    base01 = json.surfaces.dim;
    base02 = json.surfaces.surface0;
    base03 = "#7F7F7F";                # fixed mid-grey for ANSI bright-black
    base04 = json.text.overlay2;
    base05 = json.text.text;
    base06 = json.text.subtext1;
    base07 = json.text.subtext0;
    base08 = json.accents.red;
    base09 = json.accents.orange;
    base0A = json.accents.yellow;
    base0B = json.accents.green;
    base0C = json.accents.cyan;
    base0D = json.accents.blue;        # periwinkle in sturq-palette
    base0E = json.accents.magenta;
    base0F = json.accents.maroon;
  };

  roles = {
    accent     = json.core.primary;
    wallpaper  = json.surfaces.surface0;
    lockscreen = "#000000";            # OLED-black regardless of palette
  };
in {
  inherit (json) core surfaces text accents;
  inherit base16Scheme roles hexToRgb stripHash;
}

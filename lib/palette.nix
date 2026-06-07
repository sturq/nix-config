{ src }:

# Read a palette repo and expose:
#
#   base16Scheme   {base00..base0F}, bare hex (no '#'), for Stylix
#   palette        full token tree if a structured palette.json is present,
#                  else null
#   format         "json" or "base16"
#   hexToRgb       "#RRGGBB" -> "r,g,b"
#   stripHash      "#rrggbb" -> "rrggbb"
#
# Two layouts are supported. Repos that ship a structured palette under
# formats/palette.json get full token resolution; anything with a flat
# base16.yaml at the root works too. Drop in whichever palette repo you
# like, both shapes resolve to the same base16Scheme so every consumer
# (Stylix, Konsole, etc.) just keeps working.

let
  inherit (builtins)
    elemAt filter fromJSON listToAttrs map mapAttrs match pathExists
    readFile split stringLength substring;

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

  jsonPath = "${src}/formats/palette.json";
  hasJson  = pathExists jsonPath;
  json     = if hasJson then fromJSON (readFile jsonPath) else null;

  jsonBase16 =
    if !hasJson then null else mapAttrs (_: stripHash) {
      base00 = json.surfaces.crust;
      base01 = json.surfaces.dim;
      base02 = json.surfaces.surface0;
      base03 = "#7F7F7F";
      base04 = json.text.overlay2;
      base05 = json.text.text;
      base06 = json.text.subtext1;
      base07 = json.text.subtext0;
      base08 = json.accents.red;
      base09 = json.accents.orange;
      base0A = json.accents.yellow;
      base0B = json.accents.green;
      base0C = json.accents.cyan;
      base0D = json.accents.blue;
      base0E = json.accents.magenta;
      base0F = json.accents.maroon;
    };

  yamlPath =
    let
      candidates = [ "${src}/base16.yaml" "${src}/palette.yaml" ];
      found = filter pathExists candidates;
    in if found == [] then null else elemAt found 0;

  parseYaml = path:
    let
      lines = filter (l: builtins.isString l) (split "\n" (readFile path));
      one = line:
        let
          m = match
            "[[:space:]]*(base[0-9A-Fa-f]{2})[[:space:]]*:[[:space:]]*[\"']?#?([0-9A-Fa-f]{6})[\"']?[[:space:]]*"
            line;
        in if m == null then null
           else { name = elemAt m 0; value = stripHash "#${elemAt m 1}"; };
    in listToAttrs (filter (e: e != null) (map one lines));

  yamlBase16 = if yamlPath != null then parseYaml yamlPath else null;

  format =
    if jsonBase16 != null then "json"
    else if yamlBase16 != null then "base16"
    else throw "lib/palette.nix: ${src} has no formats/palette.json or base16.yaml";

  base16Scheme = if format == "json" then jsonBase16 else yamlBase16;
in {
  inherit base16Scheme hexToRgb stripHash format;
  palette = json;
}

# Parse a palette repo and expose a unified shape:
#
#   { base16Scheme, hexToRgb, stripHash, palette?, format }
#
# Two formats are auto-detected:
#
#   1. sturq-palette JSON  — formats/palette.json with core/surfaces/text/accents
#   2. base16 YAML         — base16.yaml at the repo root with base00..base0F
#
# Pass any palette repo as `src` (typically a flake = false input) and the
# right base16Scheme falls out. The `palette` attr is only populated for
# the sturq format; consumers should fall back to base16 slots when it's
# absent so the same nix-config works against any palette.
{ src }: let
  inherit (builtins) pathExists fromJSON readFile substring stringLength
                     match elemAt filter mapAttrs listToAttrs split isString;

  stripHash = s: substring 1 (stringLength s - 1) s;

  hexToRgb = hex: let
    s = substring 1 6 hex;
    h2d = c: let
      m = { "0"=0; "1"=1; "2"=2; "3"=3; "4"=4; "5"=5; "6"=6; "7"=7; "8"=8; "9"=9;
            "a"=10; "b"=11; "c"=12; "d"=13; "e"=14; "f"=15;
            "A"=10; "B"=11; "C"=12; "D"=13; "E"=14; "F"=15; };
    in m.${c};
    byte = i: 16 * (h2d (substring i 1 s)) + (h2d (substring (i+1) 1 s));
  in "${toString (byte 0)},${toString (byte 2)},${toString (byte 4)}";

  # ---- sturq JSON format -------------------------------------------------
  jsonPath = "${src}/formats/palette.json";
  hasJson  = pathExists jsonPath;

  sturqPalette = fromJSON (readFile jsonPath);

  sturqBase16 = mapAttrs (_: stripHash) {
    base00 = sturqPalette.surfaces.crust;
    base01 = sturqPalette.surfaces.dim;
    base02 = sturqPalette.surfaces.surface0;
    base03 = "#7F7F7F";
    base04 = sturqPalette.text.overlay2;
    base05 = sturqPalette.text.text;
    base06 = sturqPalette.text.subtext1;
    base07 = sturqPalette.text.subtext0;
    base08 = sturqPalette.accents.red;
    base09 = sturqPalette.accents.orange;
    base0A = sturqPalette.accents.yellow;
    base0B = sturqPalette.accents.green;
    base0C = sturqPalette.accents.cyan;
    base0D = sturqPalette.accents.blue;
    base0E = sturqPalette.accents.magenta;
    base0F = sturqPalette.accents.maroon;
  };

  # ---- base16 YAML format ------------------------------------------------
  # Look for the scheme in a few common spots: base16.yaml at root, or
  # palette.yaml (we never write to base16/<slug>.yaml because that's
  # a multi-scheme repo layout — point those at a specific file via
  # fetchurl in the consuming flake).
  yamlCandidates = [
    "${src}/base16.yaml"
    "${src}/palette.yaml"
  ];
  yamlPath = let
    found = filter pathExists yamlCandidates;
  in if found == [] then null else elemAt found 0;

  # Tiny YAML parser — base16 yaml is dead simple (flat baseXX: "hex" lines,
  # optionally under a top-level `palette:` map). Splits on \n, regex-matches
  # each line, builds an attrset. Whitespace/quotes tolerated, comments ignored.
  parseBase16Yaml = path: let
    raw   = readFile path;
    lines = filter isString (split "\n" raw);
    parseLine = line: let
      m = match "[[:space:]]*(base[0-9A-Fa-f]{2})[[:space:]]*:[[:space:]]*[\"']?#?([0-9A-Fa-f]{6})[\"']?[[:space:]]*" line;
    in if m == null then null
       else { name = elemAt m 0; value = stripHash "#${elemAt m 1}"; };
    entries = filter (x: x != null) (map parseLine lines);
  in listToAttrs entries;

  yamlBase16 = if yamlPath == null then {} else parseBase16Yaml yamlPath;

  # ---- pick a format -----------------------------------------------------
  format =
    if hasJson           then "sturq"
    else if yamlPath != null then "base16"
    else throw "palette.nix: no palette found in ${src} — expected formats/palette.json or base16.yaml";

  base16Scheme = if format == "sturq" then sturqBase16 else yamlBase16;
  palette      = if format == "sturq" then sturqPalette else null;
in {
  inherit base16Scheme hexToRgb stripHash palette format;
}

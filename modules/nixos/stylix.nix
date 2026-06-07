{ pkgs, inputs, ... }: let
  sp = import ../../lib/palette.nix { src = inputs.sturq-palette; };
  palette = sp.palette;
in {
  # Stylix → system-wide theming. One color scheme + one wallpaper that
  # downstream Stylix targets pick up. Plasma + GTK targets are off (handled
  # by plasma-manager), so Stylix here owns wallpaper, cursor, fonts,
  # the base16 palette source, and downstream targets (Firefox, Konsole, …).
  # Scheme: sturq-palette OLED (https://github.com/sturq/sturq-palette).
  # Everything comes from the palette flake — edit the repo, rebuild here.

  stylix = {
    enable = true;
    polarity = "dark";

    # base16Scheme is pre-mapped in the palette flake (Termux ANSI accents,
    # OLED surfaces, white-ramp text). Pull it whole — no hexes in this file.
    base16Scheme = sp.base16Scheme;

    # Wallpaper — solid sturq-palette base (midnight navy). Matches the
    # Android home-screen wallpaper. Primary lavender shows up as the
    # Plasma accent instead.
    image = pkgs.runCommand "wallpaper.png" {
      buildInputs = [ pkgs.imagemagick ];
    } ''
      magick -size 1920x1080 xc:'${palette.surfaces.surface0}' $out
    '';

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    # Fonts — DejaVu fallback so apps with their own font preference keep
    # using it. Roboto Flex is applied ONLY to Plasma slots via plasma-manager.
    fonts = {
      monospace = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans Mono";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      sizes = {
        applications = 11;
        terminal = 12;
        desktop = 11;
        popups = 11;
      };
    };

    # 5% transparency on terminal is the Pro look.
    opacity.terminal = 0.95;

    # Disable targets with stale upstream NixOS options on unstable.
    targets.kmscon.enable = false;
  };

  # Disable Stylix's KDE target so Plasma keeps the stock BreezeDark look —
  # Stylix maps base05=white into a near-white KDE Color background, which
  # produced a light panel even with polarity=dark. GTK target stays on
  # so libadwaita / GTK3 apps get sturq-palette via Stylix.
  home-manager.sharedModules = [
    { stylix.targets.kde.enable = false; }
  ];
}

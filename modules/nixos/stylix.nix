{ pkgs, inputs, ... }: let
  sp = import ../../lib/palette.nix { src = inputs.sturq-palette; };
  palette = sp.palette;

  # ---- Role assignment ----------------------------------------------------
  # sturq-palette is a generic palette repo — it ships colour tokens, not
  # UI roles. nix-config decides which token paints which surface. Edit
  # here if you want the wallpaper, lockscreen, etc. to use a different
  # token. The palette repo itself stays project-agnostic.
  roles = {
    wallpaper  = palette.surfaces.surface0;  # midnight navy desktop bg
    lockscreen = palette.surfaces.crust;     # pure OLED black
    terminal   = palette.surfaces.crust;     # Termux-style black bg
  };
in {
  # Stylix → system-wide theming. One scheme + one wallpaper that all
  # Stylix targets pick up. Plasma + GTK targets are off (handled by
  # plasma-manager), so Stylix here owns wallpaper, cursor, fonts, the
  # base16 source and downstream targets (Firefox, Konsole, …).

  stylix = {
    enable = true;
    polarity = "dark";

    # base16Scheme comes from lib/palette.nix (Termux ANSI accents,
    # OLED surfaces, white-ramp text). No hexes in this file.
    base16Scheme = sp.base16Scheme;

    image = pkgs.runCommand "wallpaper.png" {
      buildInputs = [ pkgs.imagemagick ];
    } ''
      magick -size 1920x1080 xc:'${roles.wallpaper}' $out
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

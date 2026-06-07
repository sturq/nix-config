{ pkgs, inputs, ... }: let
  sp = import ../../lib/palette.nix { src = inputs.sturq-palette; };

  # ---- Role assignment ----------------------------------------------------
  # sturq-palette ships colour tokens; nix-config decides which token
  # paints which surface. Roles map to base16 slots so any palette repo
  # works — point the input at a different base16 scheme and the desktop
  # repaints. If an extended sturq-format palette is present we prefer
  # its semantic tokens (e.g. surfaces.surface0 over a raw base16 slot).
  pick = jsonPath: slot:
    if sp.palette != null && jsonPath != null then jsonPath
    else "#${sp.base16Scheme.${slot}}";

  roles = {
    # selection-tier surface — feels right for a desktop bg in every
    # base16 scheme (navy in sturq, surface0 in catppuccin, gray in gruvbox).
    wallpaper  = pick (if sp.palette != null then sp.palette.surfaces.surface0 else null) "base02";
    # Lockscreen is hard-pinned to OLED black — palette-independent on purpose.
    lockscreen = "#000000";
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

  # Stylix's kde target generates a Plasma colour scheme from the palette
  # (it also covers Konsole — Konsole uses the active KDE scheme via Qt).
  # plasma-manager still owns workspace lookAndFeel + accent.
  home-manager.sharedModules = [
    { stylix.targets.kde.enable = true; }
  ];
}

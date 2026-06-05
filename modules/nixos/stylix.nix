{ pkgs, ... }: {
  # Stylix → system-wide theming. One color scheme + one wallpaper that
  # downstream Stylix targets pick up. Plasma + GTK targets are off (handled
  # by plasma-manager), so Stylix here owns wallpaper, cursor, fonts,
  # the base16 palette source, and downstream targets (Firefox, Konsole, …).
  # Scheme: sturq-palette OLED (https://github.com/sturq/sturq-palette).
  # Inlined here so we don't depend on a network fetch during rebuild.

  stylix = {
    enable = true;
    polarity = "dark";

    base16Scheme = {
      # Surfaces — OLED-friendly dark ramp, fg = Termux bright-white.
      base00 = "000000";  # mantle    — pure black (matches Termux bg)
      base01 = "1c1c1c";  # base      — lighter bg / status line
      base02 = "2A3042";  # surface0  — selection / navy tint
      base03 = "7f7f7f";  # surface1  — comments (Termux bright-black)
      base04 = "b2b2b2";  # overlay2  — dim foreground
      base05 = "e5e5e5";  # text      — default fg (Termux white)
      base06 = "f5f5f5";  # subtext1
      base07 = "ffffff";  # subtext0  — brightest fg
      # Accents — Termux default ANSI.
      base08 = "cd0000";  # red       — Termux red
      base09 = "cd5c00";  # orange    — interpolated red↔yellow
      base0A = "cdcd00";  # yellow    — Termux yellow
      base0B = "00cd00";  # green     — Termux green
      base0C = "00cdcd";  # cyan      — Termux cyan
      base0D = "0000ee";  # blue      — Termux blue (primary accent)
      base0E = "cd00cd";  # magenta   — Termux magenta
      base0F = "800000";  # maroon    — darker red
    };

    # Wallpaper — solid sturq-palette base (#2A3042, midnight navy).
    # Matches the Android home-screen wallpaper. Primary lavender #B9C5EE
    # shows up as the Plasma accent instead.
    image = pkgs.runCommand "wallpaper.png" {
      buildInputs = [ pkgs.imagemagick ];
    } ''
      magick -size 1920x1080 xc:'#2A3042' $out
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

{ pkgs, ... }: {
  # Stylix → system-wide theming. One color scheme + one wallpaper that
  # downstream Stylix targets pick up. Plasma + GTK targets are off (handled
  # by plasma-manager + adw-gtk3), so Stylix here only owns wallpaper, cursor,
  # the base16 palette source, and a few outliers (Firefox, etc.).
  # Scheme: sturq-palette OLED (https://github.com/sturq/sturq-palette).
  # Inlined here so we don't depend on a network fetch during rebuild.

  stylix = {
    enable = true;
    polarity = "dark";

    base16Scheme = {
      base00 = "060709";  # mantle    — default bg (OLED-friendly)
      base01 = "2A3042";  # base      — lighter bg
      base02 = "384058";  # surface0  — selection
      base03 = "46506E";  # surface1  — comments
      base04 = "9CA7CE";  # overlay2  — dim fg
      base05 = "FFFFFF";  # text      — default fg
      base06 = "D8DCE9";  # subtext1
      base07 = "C2CAE5";  # subtext0
      base08 = "EEB9BD";  # red
      base09 = "EECFB9";  # peach
      base0A = "EEE5B9";  # yellow
      base0B = "B9EEB9";  # green
      base0C = "B9EEE5";  # teal
      base0D = "B9C5EE";  # lavender / primary
      base0E = "DCB9EE";  # mauve
      base0F = "EEC0B9";  # maroon
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

  # Let adw-gtk3 own GTK apps. Disable Stylix's KDE target so Plasma keeps
  # the stock BreezeDark look — Stylix maps base05=white into a near-white
  # KDE Color background, which produced a light panel even with polarity=dark.
  home-manager.sharedModules = [
    {
      stylix.targets.gtk.enable = false;
      stylix.targets.kde.enable = false;
    }
  ];
}

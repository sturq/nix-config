{ pkgs, ... }: {
  # Stylix → system-wide theming. One color scheme + one wallpaper →
  # GTK, Qt, console, swaybar, foot, mako, firefox, regreet all auto-themed.
  # Scheme: sturq-palette OLED (https://github.com/sturq/sturq-palette).
  # Inlined here so we don't depend on a network fetch during rebuild.

  stylix = {
    enable = true;
    polarity = "dark";

    base16Scheme = pkgs.writeText "sturq-oled.yaml" ''
      system: "base16"
      name: "Sturq OLED"
      author: "sturq"
      slug: "sturq-oled"
      variant: "dark"
      palette:
        base00: "060709"
        base01: "2A3042"
        base02: "384058"
        base03: "46506E"
        base04: "9CA7CE"
        base05: "FFFFFF"
        base06: "D8DCE9"
        base07: "C2CAE5"
        base08: "EEB9BD"
        base09: "EECFB9"
        base0A: "EEE5B9"
        base0B: "B9EEB9"
        base0C: "B9EEE5"
        base0D: "B9C5EE"
        base0E: "DCB9EE"
        base0F: "EEC0B9"
    '';

    # Wallpaper — gradient generated from sturq-palette (base → mantle).
    image = pkgs.runCommand "wallpaper.png" {
      buildInputs = [ pkgs.imagemagick ];
    } ''
      magick -size 1920x1080 gradient:'#2A3042-#060709' $out
    '';

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.inter;
        name = "Inter";
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
}

{ pkgs, ... }: {
  # Stylix → system-wide theming. One color scheme + one wallpaper →
  # GTK, Qt, console, swaybar, foot, mako, firefox, regreet all auto-themed.
  # Scheme: Catppuccin Mocha (most popular pro dark scheme right now).

  stylix = {
    enable = true;
    polarity = "dark";

    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

    # Wallpaper — gradient generated at build time so we don't ship a binary
    # file in the repo. Swap to a fetchurl for a real photo if you want.
    image = pkgs.runCommand "wallpaper.png" {
      buildInputs = [ pkgs.imagemagick ];
    } ''
      magick -size 1920x1080 gradient:'#1e1e2e-#11111b' $out
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

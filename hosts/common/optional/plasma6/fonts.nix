{ pkgs, ... }: {
  # Fonts mirrored from sturq.github.io's CSS custom properties:
  #   --display-font = Cormorant Garamond  (hero serifs)
  #   --mono-font    = JetBrains Mono
  #   --ui-font      = system-ui (DejaVu Sans is the fallback)
  # google-fonts ships both Cormorant Garamond + JetBrains Mono.
  fonts.packages = with pkgs; [
    dejavu_fonts
    google-fonts
    material-symbols
  ];
}

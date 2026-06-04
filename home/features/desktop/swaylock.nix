{ ... }: {
  # Pure-black lockscreen with sturq-palette accent for the unlock ring.
  programs.swaylock = {
    enable = true;
    settings = {
      color = "000000";
      daemonize = true;
      ignore-empty-password = true;
      show-failed-attempts = true;
      indicator-radius = 110;
      indicator-thickness = 8;
      fade-in = "0.2";

      # Ring / state colors (sturq-palette OLED hexes, alpha = ff)
      ring-color          = "060709";
      ring-clear-color    = "EEE5B9";
      ring-caps-lock-color = "EECFB9";
      ring-ver-color      = "B9C5EE";
      ring-wrong-color    = "EEB9BD";

      inside-color        = "00000000";
      inside-clear-color  = "00000000";
      inside-ver-color    = "00000000";
      inside-wrong-color  = "00000000";

      key-hl-color        = "B9C5EE";
      bs-hl-color         = "EEB9BD";

      line-color          = "00000000";
      line-clear-color    = "00000000";
      line-ver-color      = "00000000";
      line-wrong-color    = "00000000";

      separator-color     = "00000000";

      text-color          = "FFFFFF";
      text-clear-color    = "060709";
      text-ver-color      = "060709";
      text-wrong-color    = "060709";
      text-caps-lock-color = "060709";
    };
  };
}

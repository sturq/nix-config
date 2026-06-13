{ ... }: {
  # Frosted-glass panel: same effect as sturq.github.io's top bar but
  # applied to the desktop bottom bar.
  #
  # Two pieces have to line up:
  # 1. KWin's Blur effect enabled (kwinrc Plugins.blurEnabled). Plasma 6
  #    ships it on by default but we pin it so themes can't flip it off.
  # 2. The panel needs to be in "translucent" opaque mode so KWin actually
  #    sees a translucent surface to blur behind. Plasma stores this in
  #    plasma-org.kde.plasma.desktop-appletsrc per-containment, generated
  #    only at first run, so we set it lazily at session start (same
  #    pattern the battery-percentage script uses).
  programs.plasma.configFile.kwinrc.Plugins = {
    blurEnabled = true;
    contrastEnabled = true;
  };

  # Blur radius + strength. KDE's Blur effect reads these from kwinrc;
  # we crank both up so the result looks closer to the website's
  # backdrop-filter: blur(10px) over a 70%-opacity panel.
  programs.plasma.configFile.kwinrc.Effect-blur = {
    BlurStrength = 12;
    NoiseStrength = 0;
  };

  programs.plasma.startup.startupScript."panel-translucent" = {
    runAlways = true;
    restartServices = [ "plasma-plasmashell" ];
    text = ''
      cfg="$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc"
      [ -f "$cfg" ] || exit 0
      # Find every panel containment and force translucent opaque mode (1).
      # Walking [Containments][N][General] entries: panels are
      # formfactor=2 (horizontal) or 3 (vertical), desktop containments
      # are formfactor=0 — only touch the panels.
      for c in $(grep -B1 "^formfactor=[23]$" "$cfg" \
                 | grep -oE "\[Containments\]\[[0-9]+\]" \
                 | grep -oE "[0-9]+" | sort -u); do
        kwriteconfig6 --file "$cfg" \
          --group Containments --group "$c" --group General \
          --key opaqueMode 1
      done
    '';
  };
}

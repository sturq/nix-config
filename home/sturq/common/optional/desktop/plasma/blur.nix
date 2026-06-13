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
      # Walk every [Containments][N] section; if its formfactor is 2
      # (horizontal panel) or 3 (vertical), set opaqueMode=1 to make
      # KWin's Blur effect actually kick in behind it.
      #
      # awk tracks the current containment id between section headers
      # and the next key/value lines (formfactor lives a few lines down
      # from the header, so a plain grep -B1 misses it).
      for c in $(awk '
        /^\[Containments\]\[[0-9]+\]/ {
          line = $0
          sub(/.*\[/, "", line)
          sub(/\].*/, "", line)
          current = line
        }
        /^formfactor=[23]$/ { print current }
      ' "$cfg" | sort -u); do
        kwriteconfig6 --file "$cfg" \
          --group Containments --group "$c" \
          --key opaqueMode --type int 1
      done
    '';
  };
}

{ ... }: {
  # KWin compositor tuning for an iOS-26 "liquid glass" feel on
  # vanilla Plasma — blur + contrast effects so translucent panel /
  # popup surfaces look like frosted glass, smooth slide/fade for
  # transitions, every novelty effect (wobbly windows, magic lamp,
  # glide…) off.
  programs.plasma.configFile.kwinrc = {
    Plugins = {
      blurEnabled               = true;
      contrastEnabled           = true;
      backgroundcontrastEnabled = true;
      slideEnabled              = true;
      slidingpopupsEnabled      = true;
      fadeEnabled               = true;
      magiclampEnabled          = false;
      wobblywindowsEnabled      = false;
      translucencyEnabled       = false;
      glideEnabled              = false;
      squashEnabled             = false;
      scaleEnabled              = false;
      zoomEnabled               = false;
      overviewEnabled           = false;
    };
    "Effect-blur" = {
      BlurStrength  = 15;     # heavy blur, iOS-glass thickness
      NoiseStrength = 0;
    };
    Compositing.AnimationSpeed = 2;  # default-ish, not jerky-fast
  };

  # Make panel containments translucent at session start so the Blur
  # effect actually has something to do. Panel containment ids are
  # generated at first run, so awk over the file finds them lazily.
  programs.plasma.startup.startupScript."panel-translucent" = {
    runAlways = true;
    restartServices = [ "plasma-plasmashell" ];
    text = ''
      cfg="$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc"
      [ -f "$cfg" ] || exit 0
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

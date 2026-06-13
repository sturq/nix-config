{ ... }: {
  # Plasma without compositor flourish. Visuals (palette, panel, fonts)
  # stay — only the per-frame CPU/GPU spend goes. Lets the same config
  # land on a Core 2 Duo MacBook 2,1 the same way it lands on modern
  # hardware: instant UI, no fades, no blur, no slide.
  programs.plasma.configFile.kwinrc = {
    Plugins = {
      blurEnabled              = false;
      contrastEnabled          = false;
      backgroundcontrastEnabled = false;
      slideEnabled             = false;
      slidingpopupsEnabled     = false;
      fadeEnabled              = false;
      magiclampEnabled         = false;
      wobblywindowsEnabled     = false;
      translucencyEnabled      = false;
      glideEnabled             = false;
      squashEnabled            = false;
      scaleEnabled             = false;
      zoomEnabled              = false;
      overviewEnabled          = false;
    };
    Compositing.AnimationSpeed = 0;       # instant — no easing
    "Effect-fadeDesktop".Duration = 0;
  };
}

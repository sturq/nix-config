{ lib, ... }: {
  # Profile for ancient / low-end hosts (MacBook 2,1 era + similar).
  # Goals: leave the look intact (palette + lambda) but cut every
  # GPU/CPU/RAM cost that doesn't change appearance.
  #
  # Pair this with hosts/common/optional/desktop/plasma.nix on the
  # system module side — it carries the Plasma 6 session. This file
  # only flips knobs; it doesn't pull in plasma6 itself.

  # ---- Compositor ----------------------------------------------------------
  # KWin effects: every visual flourish off. The default Breeze theme
  # still draws — just no fades, no blur, no scale animations.
  services.xserver.enable = lib.mkForce true; # X11 session, no Wayland
  services.displayManager.sddm.wayland.enable = lib.mkForce false;

  # ---- File indexing / search ---------------------------------------------
  # Baloo idles around 200-400 MB once a home dir gets walked — kill it.
  # Dolphin search falls back to plain find, which is fine.
  environment.etc."xdg/baloofilerc".text = ''
    [Basic Settings]
    Indexing-Enabled=false
  '';

  # ---- Kernel / IO --------------------------------------------------------
  # Old Core 2 Duos benefit from the BFQ scheduler and CFS autogroups.
  boot.kernel.sysctl = {
    "kernel.sched_autogroup_enabled" = 1;
    "vm.swappiness" = 10;
  };

  # ---- Power / fan / firmware -------------------------------------------
  # mbpfan keeps the old MacBook fan from screaming when idle.
  services.mbpfan.enable = true;

  # ---- Animations ---------------------------------------------------------
  # plasma-manager writes this into kwinrc, lands as an instant UI.
  home-manager.sharedModules = [{
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
      Compositing = {
        # OpenGL3 may not exist on GMA 950 — fall back to XRender.
        Backend = "XRender";
        AnimationSpeed = 0;   # instant transitions, no easing
      };
      "Effect-fadeDesktop".Duration = 0;
    };
  }];
}

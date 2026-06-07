{ pkgs, ... }: {
  # KDE Plasma 6 (Wayland) + SDDM. Per-user Plasma configuration (theme,
  # panel, hotkeys, kdeglobals) is owned by plasma-manager — see
  # home/sturq/optional/plasma6/.

  services.desktopManager.plasma6.enable = true;

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # Bare desktop — Konsole only. Everything else gets added back on
  # request so we know exactly what's installed.
  environment.systemPackages = with pkgs; [
    kdePackages.konsole
    tela-circle-icon-theme    # theming dep, not a user-facing app
  ];

  # Drop KDE defaults we don't want. Bare desktop — add apps back
  # explicitly via systemPackages or home.packages later.
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    discover         # app store — pointless on NixOS
    elisa            # music player
    khelpcenter      # help docs
    oxygen           # legacy theme
    plasma-browser-integration
    kate             # editor
    kcalc            # calculator
    kwalletmanager   # wallet UI
    spectacle        # screenshot tool (we keep it as a dep for testing)
    okular           # PDF viewer
    ark              # archive tool
    gwenview         # image viewer
    kfind            # search
    kcharselect      # char picker
    print-manager    # printer settings panel
    kmenuedit        # menu editor
  ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Force legacy snd_hda_intel driver instead of Sound Open Firmware on
  # Intel chipsets that ship SOF-capable codecs but no matching firmware
  # topology — Alder Lake laptops (HP 250 G9, Vivobook etc) regress to
  # "no soundcards" if SOF can't finish init. dsp_driver=1 == HDA-only.
  boot.extraModprobeConfig = ''
    options snd-intel-dspcfg dsp_driver=1
  '';

  # rtkit gives PipeWire realtime scheduling — without it PW logs a flood
  # of "RTKit error: ServiceUnknown" at session start.
  security.rtkit.enable = true;

  security.polkit.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs.kdePackages; [ xdg-desktop-portal-kde ];
    config.common.default = [ "kde" ];
  };

  hardware.graphics.enable = true;

  fonts.packages = with pkgs; [
    dejavu_fonts
    nerd-fonts.roboto-mono
    roboto-flex        # used by Plasma via plasma-manager
    material-symbols   # icon font for apps that want it
  ];
}

{ pkgs, ... }: {
  # KDE Plasma 6 (Wayland) + SDDM. Per-user Plasma configuration (theme,
  # panel, hotkeys, kdeglobals) is owned by plasma-manager — see
  # home/sturq/optional/plasma6/.

  services.desktopManager.plasma6.enable = true;

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    kdePackages.kdeconnect-kde
    kdePackages.kcalc
    kdePackages.filelight
    kdePackages.kate
    kdePackages.konsole       # palette-themed via Stylix
    kdePackages.partitionmanager
    fastfetch                 # palette-themed via terminal ANSI
    # Papirus folders tinted violet to match the lavender accent.
    # nixpkgs ships only blue/dark/light variants of Tela-circle which
    # clashed with the rest of the palette.
    (papirus-icon-theme.override { color = "violet"; })
  ];

  # Drop KDE defaults we don't want.
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    discover         # app store — pointless on NixOS
    elisa            # music player
    khelpcenter      # help docs
    oxygen           # legacy theme
    plasma-browser-integration
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

  # ydotool — Wayland-native keyboard/mouse synthesis (xdotool replacement).
  # Useful for debug-testing KWin scripts (Meta+Down chains etc) when
  # spectacle + D-Bus invokeShortcut isn't enough.
  programs.ydotool.enable = true;

  fonts.packages = with pkgs; [
    dejavu_fonts
    nerd-fonts.roboto-mono
    roboto-flex        # used by Plasma via plasma-manager
    material-symbols   # icon font for apps that want it
  ];
}

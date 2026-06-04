{ pkgs, ... }: {
  # KDE Plasma 6 (Wayland) + SDDM + KWin tiling.
  # Bindings match GlazeWM 1:1 — config files sync-able between Linux + Windows.

  services.desktopManager.plasma6.enable = true;

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # KWin Polonium → i3/GlazeWM-style tiling layer on top of stock KWin.
  # Installed via plasma-store-installable + autoloaded from sturq's KWin config.
  environment.systemPackages = with pkgs; [
    kdePackages.kdeconnect-kde
    kdePackages.kcalc
    kdePackages.filelight
    kdePackages.kate
    kdePackages.partitionmanager
    # GTK apps inside Plasma should pick adw-gtk3 + sturq-palette colors:
    adw-gtk3
    # Android 16 / Pixel Launcher visual stack:
    tela-circle-icon-theme   # circular Pixel-style icons
    morewaita-icon-theme     # libadwaita / Material companions
  ];

  # Drop GNOME defaults that Plasma doesn't need but NixOS sometimes pulls in.
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa            # music player
    khelpcenter      # help docs
    konsole          # we use Konsole built-in but exclude duplicate
    oxygen           # legacy theme
    plasma-browser-integration
  ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

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
    roboto-flex        # Android 16 system font (variable)
    material-symbols   # Material You icon font
  ];

  # Force Plasma into Breeze Dark by default for every login. Locks Material-You
  # accent (lavender #B9C5EE, from sturq-palette) and the Tela-circle icon set
  # which together approximate Android 16 / Pixel.
  environment.etc."xdg/kdeglobals".text = ''
    [General]
    ColorScheme=BreezeDark
    AccentColor=185,197,238
    font=Roboto Flex,11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1
    menuFont=Roboto Flex,11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1
    toolBarFont=Roboto Flex,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1
    smallestReadableFont=Roboto Flex,9,-1,5,400,0,0,0,0,0,0,0,0,0,0,1
    fixed=DejaVu Sans Mono,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,0

    [Icons]
    Theme=Tela-circle-dark

    [KDE]
    LookAndFeelPackage=org.kde.breezedark.desktop
    SingleClick=false
    AnimationDurationFactor=0.5

    [WM]
    activeFont=Roboto Flex,11,-1,5,500,0,0,0,0,0,0,0,0,0,0,1
  '';

  # KWin has built-in window tiling on Plasma 6 — bound to Meta+T (tile
  # editor) + drag-to-edge by default. For full i3/GlazeWM-style tiling, the
  # user can install Polonium or Kröhnkite from Plasma Discover; not packaged
  # in nixpkgs upstream.
}

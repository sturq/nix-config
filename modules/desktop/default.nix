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
  ];

  # Force Plasma into Breeze Dark by default for every login.
  # Stylix overrides the color values but the look-and-feel package selection
  # itself is locked here so nothing falls back to light.
  environment.etc."xdg/kdeglobals".text = ''
    [General]
    ColorScheme=BreezeDark

    [KDE]
    LookAndFeelPackage=org.kde.breezedark.desktop
    SingleClick=false
  '';

  # KWin has built-in window tiling on Plasma 6 — bound to Meta+T (tile
  # editor) + drag-to-edge by default. For full i3/GlazeWM-style tiling, the
  # user can install Polonium or Kröhnkite from Plasma Discover; not packaged
  # in nixpkgs upstream.
}

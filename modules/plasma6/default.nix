{ pkgs, ... }: {
  # KDE Plasma 6 (Wayland) + SDDM. Per-user Plasma configuration (theme,
  # panel, hotkeys, kdeglobals) is owned by plasma-manager — see
  # home/features/plasma6/config.nix.

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
    kdePackages.partitionmanager
    # Pixel-style circular icon set used by Plasma.
    tela-circle-icon-theme
  ];

  # Drop KDE defaults we don't want.
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
    roboto-flex        # used by Plasma via plasma-manager
    material-symbols   # icon font for apps that want it
  ];
}

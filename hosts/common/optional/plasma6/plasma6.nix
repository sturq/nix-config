{ pkgs, ... }: {
  # KDE Plasma 6 (Wayland). User-side config in home/sturq/features/desktop.
  services.desktopManager.plasma6.enable = true;

  # plasma-manager writes dconf for some KDE bits — needs dconf enabled.
  programs.dconf.enable = true;

  # Bare desktop — Konsole only. Apps added back via
  # hosts/common/optional/applications.
  environment.systemPackages = [ pkgs.kdePackages.konsole ];

  security.polkit.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs.kdePackages; [ xdg-desktop-portal-kde ];
    config.common.default = [ "kde" ];
  };
}

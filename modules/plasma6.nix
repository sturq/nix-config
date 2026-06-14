{ pkgs, ... }: {
  # KDE Plasma 6 (Wayland) — system side. User config: home/sturq/plasma.
  services.desktopManager.plasma6.enable = true;

  # plasma-manager writes dconf for some KDE bits.
  programs.dconf.enable = true;

  # Bare desktop — Konsole only. Apps added via modules/keepassxc.nix etc.
  environment.systemPackages = [ pkgs.kdePackages.konsole ];

  security.polkit.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs.kdePackages; [ xdg-desktop-portal-kde ];
    config.common.default = [ "kde" ];
  };

  # Drop KDE defaults we don't want.
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    discover                    # app store — pointless on NixOS
    elisa                       # music player
    khelpcenter                 # help docs
    oxygen                      # legacy theme
    plasma-browser-integration
    kate                        # editor
    kcalc                       # calculator
    kwalletmanager              # wallet UI
    okular                      # PDF viewer
    ark                         # archive tool
    gwenview                    # image viewer
    kfind                       # search
    kcharselect                 # char picker
    print-manager               # printer settings panel
    kmenuedit                   # menu editor
  ];

  # Baloo file indexing off — sits at 200-400 MB after walking a home
  # dir; Dolphin search falls back to find/locate which is plenty.
  environment.etc."xdg/baloofilerc".text = ''
    [Basic Settings]
    Indexing-Enabled=false
  '';
}

{ pkgs, lib, ... }: {
  # User-level desktop config: apps + GTK theming (adw-gtk3 for all GTK apps).
  # Plasma side gets themed by Stylix automatically.

  home.packages = with pkgs; [
    firefox
    keepassxc
    yazi
    helix
    zathura
    mpv
    imv
  ];

  # adw-gtk3-dark for every GTK app — matches the Plasma dark side visually.
  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };

  # Prefer dark color scheme — libadwaita & GTK4 apps honor this.
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
}

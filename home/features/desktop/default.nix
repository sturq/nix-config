{ pkgs, lib, ... }: {
  imports = [ ./plasma.nix ];

  # User-level desktop config: apps + GTK theming. Plasma is owned by
  # plasma-manager (./plasma.nix).

  home.packages = with pkgs; [
    firefox
    keepassxc
    yazi
    helix
    zathura
    mpv
    imv
  ];

  # adw-gtk3-dark + Tela-circle-dark icons. No font override here — apps
  # that have their own font preference (Firefox, etc.) keep using it.
  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "Tela-circle-dark";
      package = pkgs.tela-circle-icon-theme;
    };
  };

  # Prefer dark color scheme — libadwaita & GTK4 apps honor this.
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
}

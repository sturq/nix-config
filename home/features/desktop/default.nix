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

  # GTK icon theme = Tela-circle-dark. The GTK theme itself is owned by
  # Stylix (sturq-palette base16). No font override — apps with their own
  # font (Firefox, etc.) keep using it.
  gtk = {
    enable = true;
    iconTheme = {
      name = "Tela-circle-dark";
      package = pkgs.tela-circle-icon-theme;
    };
  };

  # Prefer dark color scheme — libadwaita & GTK4 apps honor this.
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
}

{ pkgs, ... }: {
  # Declarative GTK + Qt theming — dark, tiler-friendly, NixOS-idiomatic.
  # - adw-gtk3: Adwaita-dark backported for GTK3 apps (Firefox, KeePassXC, etc.)
  # - Adwaita-Qt: Qt apps follow the same look via qt.platformTheme=adwaita.
  # - gtk-decoration-layout=appmenu: → no min/max/close buttons on CSD apps
  #   (tiling WM handles window ops; the buttons are dead weight).

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
    cursorTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-decoration-layout = "appmenu:";
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-decoration-layout = "appmenu:";
    };
  };

  # Color-scheme hint (adw-gtk3, libadwaita, electron-apps all honor it).
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    gtk.enable = true;
  };
}

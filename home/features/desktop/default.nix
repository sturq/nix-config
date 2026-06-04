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

  # adw-gtk3-dark + Tela-circle-dark icons = Android-16-ish GTK side.
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
    font = {
      name = "Roboto Flex";
      package = pkgs.roboto-flex;
      size = 11;
    };
  };

  # Prefer dark color scheme — libadwaita & GTK4 apps honor this.
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

  # Plasma power policy: never sleep on AC, only on battery.
  xdg.configFile."powerdevilrc".text = ''
    [AC]
    icon=battery-charging

    [AC][SuspendAndShutdown]
    AutoSuspendAction=0
    LidAction=0
    PowerButtonAction=14

    [AC][Display]
    TurnOffDisplayWhenIdle=false

    [Battery]
    icon=battery-060

    [Battery][SuspendAndShutdown]
    AutoSuspendAction=1
    AutoSuspendIdleTimeoutSec=900
    LidAction=1

    [Battery][Display]
    TurnOffDisplayWhenIdle=true
    TurnOffDisplayIdleTimeoutSec=600

    [LowBattery]
    icon=battery-low

    [LowBattery][SuspendAndShutdown]
    AutoSuspendAction=2
    AutoSuspendIdleTimeoutSec=300
  '';

  # Screen-lock policy: on AC the screen *only locks* (no suspend, no display
  # off — see powerdevilrc above). On battery: lock + suspend.
  xdg.configFile."kscreenlockerrc".text = ''
    [Daemon]
    Autolock=true
    LockOnResume=true
    Timeout=10
  '';
}

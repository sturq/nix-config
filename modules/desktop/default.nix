{ pkgs, ... }: {
  # Sway-based Wayland desktop. Pure-Nix declarative — keybinds + layout live
  # in home/features/desktop/sway.nix, this file just provides system bits.

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  # ReGreet — modern GTK4 graphical greeter, runs as Wayland session via cage.
  # Standard sway-pro choice. Theme inherits adw-gtk3-dark via gtk settings.
  programs.regreet = {
    enable = true;
    settings = {
      GTK = {
        application_prefer_dark_theme = true;
        cursor_theme_name = "Adwaita";
        font_name = "Inter 14";
        icon_theme_name = "Adwaita";
        theme_name = "adw-gtk3-dark";
      };
      background = {
        color = "#111111";
      };
    };
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  security.polkit.enable = true;
  # swaylock needs a PAM service registered to authenticate user passwords.
  security.pam.services.swaylock = {};

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
    wlr.enable = true;
  };

  hardware.graphics.enable = true;

  fonts.packages = with pkgs; [
    inter
    nerd-fonts.jetbrains-mono
  ];

  # System-wide Wayland helpers (the rest of the suckless-style stack).
  environment.systemPackages = with pkgs; [
    foot           # terminal
    wmenu          # app launcher (replaces dmenu)
    swaylock       # screen locker
    swayidle       # idle timeout (used if user wants auto-lock)
    grim           # screenshot
    slurp          # region picker
    wl-clipboard   # wl-copy / wl-paste
    mako           # notifications
    wob            # volume/brightness OSD
    brightnessctl  # XF86 brightness keys helper
  ];
}

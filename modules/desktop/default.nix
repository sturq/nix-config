{ pkgs, ... }: {
  # Sway-based Wayland desktop. Pure-Nix declarative — keybinds + layout live
  # in home/features/desktop/sway.nix, this file just provides system bits.

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  # ReGreet — modern GTK4 graphical greeter, runs as Wayland session via cage.
  # Theme/font/cursor handled by Stylix automatically.
  programs.regreet.enable = true;

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

  # Fonts: DejaVu (Stylix fallback, system-wide) + RobotoMono Nerd (waybar only).
  fonts.packages = with pkgs; [
    dejavu_fonts
    nerd-fonts.roboto-mono
  ];

  # System-wide Wayland helpers — all native Wayland.
  environment.systemPackages = with pkgs; [
    foot           # terminal — Wayland-native
    fuzzel         # app launcher — modern Wayland-native (replaces wmenu/dmenu)
    swaylock       # screen locker — Wayland-native
    swayidle       # idle timeout — Wayland-native
    grim           # screenshot — Wayland-native
    slurp          # region picker — Wayland-native
    wl-clipboard   # wl-copy / wl-paste — Wayland-native
    mako           # notifications — Wayland-native
    wob            # volume/brightness OSD — Wayland-native
    brightnessctl  # XF86 brightness key helper (platform-agnostic, no Wayland alt needed)
  ];
}

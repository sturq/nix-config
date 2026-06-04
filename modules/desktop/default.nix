{ pkgs, ... }:

let
  # Custom dwl with sturq's config.h compiled in (ALT modkey, wmenu launcher).
  # Bump wlr_layer_shell_v1 v3 → v4 so somebar 1.0.3 can bind (dwl 0.8 hardcodes v3).
  dwl-sturq = (pkgs.dwl.override {
    conf = ./config.h;
  }).overrideAttrs (old: {
    postPatch = (old.postPatch or "") + "\n" + ''
      sed -i 's/wlr_layer_shell_v1_create(dpy, 3)/wlr_layer_shell_v1_create(dpy, 4)/' dwl.c
    '';
  });
in
{
  # Greetd → tuigreet (manual login). For autologin import ./autologin.nix.
  # tuigreet is a TUI greeter — matches suckless aesthetic, ~50 MB footprint
  # vs GDM ~500 MB, no Wayland session for greeter = better idle power.
  # Theme colors picked to match dwl's bordercolor (gray) + focuscolor (blue).
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --asterisks --theme 'border=blue;text=white;prompt=blue;time=cyan;action=white;button=blue;container=black;input=white;greet=blue' --cmd dwl-start";
      user = "greeter";
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
    config.common.default = [ "wlr" ];
  };

  hardware.graphics.enable = true;

  fonts.packages = with pkgs; [
    inter
    nerd-fonts.jetbrains-mono
  ];

  environment.systemPackages = let
    dwlStart = pkgs.writeShellScriptBin "dwl-start" ''
      exec ${dwl-sturq}/bin/dwl -s "${pkgs.somebar}/bin/somebar"
    '';
  in [
    # Suckless-style Wayland stack
    dwlStart
    dwl-sturq          # compositor (dwm for Wayland)
    pkgs.somebar       # status bar
    pkgs.wmenu         # app launcher (Mod+p)
    pkgs.foot          # terminal — minimal Wayland-native (replaces st)
    pkgs.mako          # notification daemon
    pkgs.swaylock      # screen locker (replaces slock)
    pkgs.swayidle      # idle timeout → run swaylock
    pkgs.grim          # screenshot (replaces scrot)
    pkgs.slurp         # region selector for grim
    pkgs.wl-clipboard  # wl-copy / wl-paste (replaces xclip)
    pkgs.wob           # bar overlay for volume/brightness
    pkgs.brightnessctl # XF86 brightness keys helper
  ];
}

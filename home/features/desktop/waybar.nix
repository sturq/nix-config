{ pkgs, ... }: {
  # Waybar — the pretty Pro Sway/Hyprland status bar.
  # Stylix auto-themes colors+fonts; this file only defines layout+modules.
  programs.waybar = {
    enable = true;
    systemd.enable = true;  # autostart with the Wayland session

    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 30;
      spacing = 4;

      modules-left   = [ "sway/workspaces" "sway/mode" ];
      modules-center = [ "sway/window" ];
      modules-right  = [ "pulseaudio" "network" "battery" "clock" "tray" ];

      "sway/workspaces" = {
        disable-scroll = true;
        all-outputs = true;
      };
      "sway/window".max-length = 60;

      clock = {
        format = "  {:%a %d %b  %H:%M}";
        tooltip-format = "<tt>{calendar}</tt>";
      };

      battery = {
        format = "{icon}  {capacity}%";
        format-charging = "  {capacity}%";
        format-icons = [ "" "" "" "" "" ];
        states = {
          warning = 25;
          critical = 10;
        };
      };

      network = {
        format-wifi = "  {essid} ({signalStrength}%)";
        format-ethernet = "  {ifname}";
        format-disconnected = "⚠  offline";
        tooltip-format = "{ifname}: {ipaddr}";
      };

      pulseaudio = {
        format = "{icon}  {volume}%";
        format-muted = "  muted";
        format-icons = { default = [ "" "" "" ]; };
        on-click = "pavucontrol";
      };

      tray.spacing = 8;
    };
  };
}

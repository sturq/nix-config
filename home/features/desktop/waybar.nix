{ pkgs, ... }: {
  # Waybar — the pretty Pro Sway/Hyprland status bar.
  # Stylix auto-themes colors+fonts; this file only defines layout+modules.
  programs.waybar = {
    enable = true;
    systemd.enable = true;  # autostart with the Wayland session

    # Override Stylix's auto-theming: bar = wallpaper base color (#2A3042),
    # accent = palette primary (#B9C5EE).
    style = ''
      * {
        font-family: 'JetBrainsMono Nerd Font Mono', monospace;
        font-size: 12px;
        min-height: 0;
      }
      window#waybar {
        background: #2A3042;
        color: #FFFFFF;
        border: none;
      }
      #workspaces button {
        padding: 2px 10px;
        color: #9CA7CE;
        background: transparent;
        border-radius: 4px;
        margin: 4px 2px;
      }
      #workspaces button.focused,
      #workspaces button.active {
        background: #B9C5EE;
        color: #2A3042;
      }
      #workspaces button:hover {
        background: #46506E;
        color: #FFFFFF;
        box-shadow: none;
        text-shadow: none;
      }
      #window {
        color: #C2CAE5;
        padding: 0 8px;
      }
      #clock,
      #battery,
      #network,
      #pulseaudio,
      #tray {
        padding: 0 10px;
        color: #FFFFFF;
      }
      #battery.warning   { color: #EEE5B9; }
      #battery.critical  { color: #EEB9BD; }
      #network.disconnected { color: #EEB9BD; }
    '';

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

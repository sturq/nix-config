{ pkgs, ... }: {
  # Waybar — top bar with useful stats (no SSID — nobody cares which AP).
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    style = ''
      * {
        font-family: 'RobotoMono Nerd Font Mono', monospace;
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
      #cpu, #memory, #disk, #network, #pulseaudio, #battery, #clock, #tray {
        padding: 0 10px;
        color: #FFFFFF;
      }
      #cpu.high      { color: #EEE5B9; }
      #cpu.critical  { color: #EEB9BD; }
      #memory.high   { color: #EEE5B9; }
      #memory.critical { color: #EEB9BD; }
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
      modules-right  = [ "cpu" "memory" "disk" "network" "pulseaudio" "battery" "clock" "tray" ];

      "sway/workspaces" = {
        disable-scroll = true;
        all-outputs = true;
      };
      "sway/window".max-length = 50;

      cpu = {
        interval = 5;
        format = "  {usage}%";
        states = { high = 70; critical = 90; };
      };

      memory = {
        interval = 5;
        format = "  {percentage}%";
        tooltip-format = "{used:0.1f}G / {total:0.1f}G";
        states = { high = 70; critical = 90; };
      };

      disk = {
        interval = 60;
        format = "  {percentage_used}%";
        path = "/";
      };

      network = {
        interval = 3;
        format-wifi = "  {bandwidthDownBits} ↓ {bandwidthUpBits} ↑";
        format-ethernet = "  {bandwidthDownBits} ↓ {bandwidthUpBits} ↑";
        format-disconnected = "⚠  offline";
        tooltip-format = "{ifname}: {ipaddr}";
      };

      pulseaudio = {
        format = "{icon}  {volume}%";
        format-muted = "  muted";
        format-icons = { default = [ "" "" "" ]; };
        on-click = "pavucontrol";
      };

      battery = {
        format = "{icon}  {capacity}%";
        format-charging = "  {capacity}%";
        format-icons = [ "" "" "" "" "" ];
        states = { warning = 25; critical = 10; };
      };

      clock = {
        format = "  {:%a %d %b  %H:%M}";
        tooltip-format = "<tt>{calendar}</tt>";
      };

      tray.spacing = 8;
    };
  };
}

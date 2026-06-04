{ pkgs, lib, ... }:
let
  modifier = "Mod4";  # Windows / Super key
in
{
  wayland.windowManager.sway = {
    enable = true;
    config = {
      inherit modifier;
      terminal = "foot";
      menu = "wmenu-run";
      defaultWorkspace = "workspace number 1";

      input."type:touchpad" = {
        tap = "enabled";
        natural_scroll = "enabled";
        dwt = "enabled";          # disable-while-typing
        accel_profile = "adaptive";
      };

      input."type:keyboard" = {
        xkb_layout = "de";
        repeat_rate = "50";
        repeat_delay = "300";
      };

      keybindings = {
        # ── Windows-native essentials ─────────────────────────────
        "${modifier}+Return"       = "exec foot";                  # Win+Enter → terminal
        "${modifier}+r"            = "exec wmenu-run";             # Win+R → run
        "${modifier}+e"            = "exec foot -e yazi";          # Win+E → files
        "${modifier}+l"            = "exec swaylock -f";           # Win+L → lock
        "${modifier}+q"            = "kill";                       # Win+Q → close window
        "Mod1+F4"                  = "kill";                       # Alt+F4 → close window
        "${modifier}+Shift+q"      = "exit";                       # Win+Shift+Q → logout sway

        # ── Focus (Win-Tab + Alt-Tab) ─────────────────────────────
        "${modifier}+Tab"          = "focus next";
        "${modifier}+Shift+Tab"    = "focus prev";
        "Mod1+Tab"                 = "focus next";

        # vi-style focus
        "${modifier}+j"            = "focus down";
        "${modifier}+k"            = "focus up";
        "${modifier}+h"            = "focus left";

        # ── Layouts ───────────────────────────────────────────────
        "${modifier}+d"            = "layout toggle split";        # Win+D → split tiling
        "${modifier}+t"            = "layout toggle split";
        "${modifier}+f"            = "floating toggle";            # Win+F → toggle floating
        "${modifier}+m"            = "layout tabbed";              # Win+M → tabbed (monocle-ish)
        "${modifier}+Up"           = "fullscreen toggle";          # Win+Up → maximize
        "${modifier}+space"        = "floating toggle";

        # ── Resize (Win+arrows) ───────────────────────────────────
        "${modifier}+Left"         = "resize shrink width 50px";
        "${modifier}+Right"        = "resize grow width 50px";
        "${modifier}+Down"         = "resize shrink height 50px";

        # ── Workspaces 1..9 (Win-1..9 / Win-Shift-1..9) ────────────
        "${modifier}+1" = "workspace number 1";
        "${modifier}+2" = "workspace number 2";
        "${modifier}+3" = "workspace number 3";
        "${modifier}+4" = "workspace number 4";
        "${modifier}+5" = "workspace number 5";
        "${modifier}+6" = "workspace number 6";
        "${modifier}+7" = "workspace number 7";
        "${modifier}+8" = "workspace number 8";
        "${modifier}+9" = "workspace number 9";
        "${modifier}+Shift+1" = "move container to workspace number 1";
        "${modifier}+Shift+2" = "move container to workspace number 2";
        "${modifier}+Shift+3" = "move container to workspace number 3";
        "${modifier}+Shift+4" = "move container to workspace number 4";
        "${modifier}+Shift+5" = "move container to workspace number 5";
        "${modifier}+Shift+6" = "move container to workspace number 6";
        "${modifier}+Shift+7" = "move container to workspace number 7";
        "${modifier}+Shift+8" = "move container to workspace number 8";
        "${modifier}+Shift+9" = "move container to workspace number 9";

        # ── Screenshots (Windows-style) ───────────────────────────
        "Print"                    = ''exec grim ~/Pictures/screen-$(date +%s).png'';
        "Shift+Print"              = ''exec grim -g "$(slurp)" ~/Pictures/screen-$(date +%s).png'';
        "${modifier}+Shift+s"      = ''exec grim -g "$(slurp)" - | wl-copy'';

        # ── Volume / brightness (XF86 keys) ───────────────────────
        "XF86AudioRaiseVolume"     = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
        "XF86AudioLowerVolume"     = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        "XF86AudioMute"            = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        "XF86AudioMicMute"         = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
        "XF86MonBrightnessUp"      = "exec brightnessctl set +5%";
        "XF86MonBrightnessDown"    = "exec brightnessctl set 5%-";

        # ── Reload sway config ────────────────────────────────────
        "${modifier}+Shift+c"      = "reload";
      };

      # No swaybar — waybar is started by its systemd user service.
      bars = [ ];

      window = {
        border = 2;
        titlebar = false;       # tiler-style, no per-window titlebars
      };

      gaps = {
        inner = 6;
        outer = 4;
      };
    };
  };
}

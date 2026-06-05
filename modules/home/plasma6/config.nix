{ pkgs, lib, ... }: {
  # Declarative KDE Plasma 6 — panels, shortcuts, kdeglobals, power, lock.
  programs.plasma = {
    enable = true;

    workspace = {
      colorScheme = "BreezeDark";
      lookAndFeel = "org.kde.breezedark.desktop";
      iconTheme = "Tela-circle-dark";
      cursor = {
        theme = "Bibata-Modern-Classic";
        size = 24;
      };
    };

    # Windows-11-style panel: Start + pager + tasks centered as a group
    # via flanking expanding spacers, right cluster pinned to the right.
    panels = [{
      location = "bottom";
      floating = true;       # stock-KDE float; auto-hides on fullscreen apps
      height = 44;
      widgets = [
        { name = "org.kde.plasma.panelspacer"; config.General.expanding = "true"; }
        "org.kde.plasma.kickoff"
        {
          name = "org.kde.plasma.pager";
          config.General.showWindowIcons = "true";
        }
        {
          name = "org.kde.plasma.icontasks";
          config.General = {
            launchers = "";
            groupingStrategy = "1";
            showOnlyCurrentDesktop = "true";
          };
        }
        { name = "org.kde.plasma.panelspacer"; config.General.expanding = "true"; }
        # Single systemtray. battery/volume/network pinned visible; every
        # other plasmoid + SNI app (Steam, Discord, etc.) goes into the
        # overflow popup behind the ^. (Two trays caused SNI duplication.)
        {
          name = "org.kde.plasma.systemtray";
          config.General = {
            shownItems = "org.kde.plasma.battery,org.kde.plasma.volume,org.kde.plasma.networkmanagement";
            hiddenItems = lib.concatStringsSep "," [
              # Plasmoid extras we don't want pinned
              "org.kde.plasma.brightness"
              "org.kde.plasma.bluetooth"
              "org.kde.plasma.clipboard"
              "org.kde.plasma.notifications"
              "org.kde.plasma.keyboardlayout"
              "org.kde.plasma.keyboardindicator"
              "org.kde.plasma.devicenotifier"
              "org.kde.plasma.weather"
              "org.kde.kscreen"
              "org.kde.kdeconnect"
              "org.kde.plasma.cameraindicator"
              "org.kde.plasma.manage-inputmethod"
              "org.kde.plasma.mediacontroller"
              # Status-Notifier-Item app IDs that should auto-collapse into
              # the overflow (Win11-style notification area).
              "Steam"
              "discord"
              "spotify"
              "vinegarhq.Sober"
            ];
          };
        }
        {
          name = "org.kde.plasma.digitalclock";
          config.Appearance = {
            use24hFormat = "2";              # 2 = 24h
            showSeconds = "2";               # 2 = always in panel
            showDate = "true";
            dateFormat = "custom";
            customDateFormat = "d/M/yyyy";   # 5/6/2026
            autoFontAndSize = "false";
            fontFamily = "Roboto Flex";
            fontWeight = "400";
            boldText = "false";
            italicText = "false";
            fontSize = "9";
          };
        }
        # Win11-style "Show Desktop" sliver at the right edge: a thin
        # non-expanding spacer that's just narrow enough to look like the
        # invisible strip on Windows 11. Click action via the Meta+D
        # global shortcut (see `shortcuts` below).
        { name = "org.kde.plasma.panelspacer"; config.General = { expanding = "false"; length = "6"; }; }
      ];
    }];

    # Windows-style global shortcuts — modelled on Windows 11 defaults.
    shortcuts = {
      # App launchers
      "services/org.kde.dolphin.desktop"."_launch"           = "Meta+E";
      "services/org.kde.krunner.desktop"."_launch"           = [ "Meta+R" "Meta+S" ];
      "services/systemsettings.desktop"."_launch"            = "Meta+I";
      "services/org.kde.spectacle.desktop"."_launch"         = "Meta+Shift+S";
      "services/org.kde.plasma-systemmonitor.desktop"."_launch" = "Ctrl+Shift+Escape";

      # Windows / KWin
      "kwin"."Show Desktop"          = "Meta+D";
      "kwin"."Window Maximize"       = "Meta+Up";
      "kwin"."Window Minimize"       = "Meta+Down";
      "kwin"."Window Quick Tile Left"  = "Meta+Left";
      "kwin"."Window Quick Tile Right" = "Meta+Right";
      "kwin"."Overview"              = "Meta+Tab";   # Win11 Task View
      "kwin"."Walk Through Windows"  = "Alt+Tab";

      # Lock / power
      "ksmserver"."Lock Session" = [ "Meta+L" "Screensaver" ];

      # Plasma extras
      "plasmashell"."show emoji selector" = "Meta+.";
      "plasmashell"."manage activities"   = "Meta+Q";
      "plasmashell"."clipboard_action"    = "Meta+V";

      # Virtual desktops — Win11 bindings
      "kwin"."Switch One Desktop to the Left"  = "Meta+Ctrl+Left";
      "kwin"."Switch One Desktop to the Right" = "Meta+Ctrl+Right";
      "kwin"."Add Virtual Desktop"             = "Meta+Ctrl+D";
      "kwin"."Remove Virtual Desktop"          = "Meta+Ctrl+F4";

      # Display
      "kded6"."display"                = "Meta+P";   # Win+P display switch
    };

    # Battery applet inside the systemtray: show percentage next to icon.
    # The applet's containment ID is dynamic, so we discover it at startup.
    startup.startupScript."sturq-battery-percentage" = {
      text = ''
        cfg="$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc"
        [ -f "$cfg" ] || exit 0
        # For every battery applet inside any systemtray containment, set
        # showPercentage=true via kwriteconfig.
        grep -B2 "plugin=org.kde.plasma.battery" "$cfg" \
          | grep -oE "\[Containments\]\[[0-9]+\]\[Applets\]\[[0-9]+\]\[Applets\]\[[0-9]+\]" \
          | while read header; do
            c=$(echo "$header" | grep -oE "[0-9]+" | sed -n 1p)
            a=$(echo "$header" | grep -oE "[0-9]+" | sed -n 2p)
            b=$(echo "$header" | grep -oE "[0-9]+" | sed -n 3p)
            kwriteconfig6 --file "$cfg" \
              --group Containments --group "$c" \
              --group Applets --group "$a" \
              --group Applets --group "$b" \
              --group Configuration --group General \
              --key showPercentage true
          done
      '';
      runAlways = true;
      restartServices = [ "plasma-plasmashell" ];
    };

    configFile = {
      # Fonts: Roboto Flex everywhere in Plasma, DejaVu Sans Mono for fixed.
      kdeglobals."General" = {
        AccentColor = "185,197,238";
        font = "Roboto Flex,11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
        menuFont = "Roboto Flex,11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
        toolBarFont = "Roboto Flex,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
        smallestReadableFont = "Roboto Flex,9,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
        fixed = "DejaVu Sans Mono,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,0";
      };
      kdeglobals."KDE" = {
        SingleClick = false;
        AnimationDurationFactor = 0.5;
      };
      kdeglobals."WM"."activeFont" = "Roboto Flex,11,-1,5,500,0,0,0,0,0,0,0,0,0,0,1";

      # Power policy — AC: lock only, no sleep; battery: sleep+lock.
      powerdevilrc."AC/SuspendAndShutdown" = {
        AutoSuspendAction = 0;
        LidAction = 0;
        PowerButtonAction = 14;
      };
      powerdevilrc."AC/Display".TurnOffDisplayWhenIdle = false;
      powerdevilrc."Battery/SuspendAndShutdown" = {
        AutoSuspendAction = 1;
        AutoSuspendIdleTimeoutSec = 900;
        LidAction = 1;
      };
      powerdevilrc."Battery/Display" = {
        TurnOffDisplayWhenIdle = true;
        TurnOffDisplayIdleTimeoutSec = 600;
      };
      powerdevilrc."LowBattery/SuspendAndShutdown" = {
        AutoSuspendAction = 2;
        AutoSuspendIdleTimeoutSec = 300;
      };

      # Lockscreen = solid OLED-mantle #060709.
      kscreenlockerrc.Daemon = {
        Autolock = true;
        LockOnResume = true;
        Timeout = 10;
      };
      kscreenlockerrc.Greeter.WallpaperPlugin = "org.kde.color";
      kscreenlockerrc."Greeter/Wallpaper/org.kde.color/General".Color = "6,7,9";
    };
  };
}

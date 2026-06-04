{ pkgs, ... }: {
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

    # Windows-11-style panel: Start + tasks centered as a group via flanking
    # spacers; system tray + clock + show-desktop on the right.
    panels = [{
      location = "bottom";
      floating = false;
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
        "org.kde.plasma.systemtray"
        "org.kde.plasma.digitalclock"
        "org.kde.plasma.showdesktop"
      ];
    }];

    # Windows-style global shortcuts.
    shortcuts = {
      # App launchers
      "services/org.kde.dolphin.desktop"."_launch" = "Meta+E";
      "services/org.kde.krunner.desktop"."_launch" = "Meta+R";
      "services/systemsettings.desktop"."_launch" = "Meta+I";

      # Windows behaviour
      "kwin"."Show Desktop" = "Meta+D";
      "kwin"."Window Maximize" = "Meta+Up";
      "kwin"."Window Minimize" = "Meta+Down";
      "kwin"."Overview" = "Meta+Tab";              # Win11 Task View
      "ksmserver"."Lock Session" = [ "Meta+L" "Screensaver" ];
      "plasmashell"."show emoji selector" = "Meta+.";

      # Virtual desktops — Win11 bindings
      "kwin"."Switch One Desktop to the Left"  = "Meta+Ctrl+Left";
      "kwin"."Switch One Desktop to the Right" = "Meta+Ctrl+Right";
      "kwin"."Add Virtual Desktop"             = "Meta+Ctrl+D";
      "kwin"."Remove Virtual Desktop"          = "Meta+Ctrl+F4";
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

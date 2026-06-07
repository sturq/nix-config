{ pkgs, lib, inputs, ... }:

let
  palette = import ../../../lib/palette.nix { src = inputs.sturq-palette; };

  pickToken = jsonPath: slot:
    if palette.palette != null && jsonPath != null
    then jsonPath
    else "#${palette.base16Scheme.${slot}}";

  roles = {
    accent = pickToken
      (if palette.palette != null then palette.palette.core.primary else null)
      "base0D";

    wallpaper = pickToken
      (if palette.palette != null then palette.palette.surfaces.surface0 else null)
      "base02";

    lockscreen = "#000000";
  };

  # plasma-manager owns the wallpaper because Stylix's KDE target forced a
  # light scheme on us before; the solid PNG goes through workspace.wallpaper.
  wallpaperImage = pkgs.runCommand "wallpaper.png" {
    buildInputs = [ pkgs.imagemagick ];
  } "magick -size 1920x1080 xc:'${roles.wallpaper}' $out";

  rgb = palette.hexToRgb;

  systrayHidden = builtins.concatStringsSep "," [
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
  ];

  # SNI ids of apps we want to drop into the overflow popup instead of the
  # visible tray (Plasma 6 hard-codes the overflow arrow on the right).
  sniOverflow = "steam,discord,spotify,sober";
in {
  programs.plasma = {
    enable = true;

    workspace = {
      colorScheme = "BreezeDark";
      lookAndFeel = "org.kde.breezedark.desktop";
      iconTheme   = "Tela-circle-dark";
      wallpaper   = "${wallpaperImage}";
      cursor = { theme = "Bibata-Modern-Classic"; size = 24; };
    };

    # Bottom panel laid out Win11-style: kickoff + tasks centred between two
    # expanding spacers; the status cluster pinned to the right uses two
    # systemtrays so the overflow arrow ends up on the LEFT of the icons.
    panels = [{
      location = "bottom";
      floating = true;
      height = 44;
      widgets = [
        { name = "org.kde.plasma.panelspacer"; config.General.expanding = "true"; }

        "org.kde.plasma.kickoff"

        {
          name = "org.kde.plasma.icontasks";
          config.General = {
            launchers = "";
            groupingStrategy = "1";
            showOnlyCurrentDesktop = "true";
          };
        }

        { name = "org.kde.plasma.panelspacer"; config.General.expanding = "true"; }

        # Overflow-only tray. Every plasmoid extra + SNI app is listed here
        # so they exist, then hidden so the only visible thing is the arrow.
        {
          name = "org.kde.plasma.systemtray";
          config.General = {
            extraItems  = "${systrayHidden},${sniOverflow}";
            shownItems  = "";
            hiddenItems = "${systrayHidden},${sniOverflow}";
          };
        }

        # Visible status icons. SNI apps are disabled here so Steam/Discord
        # don't double up next to the battery/volume/network triplet.
        {
          name = "org.kde.plasma.systemtray";
          config.General = {
            extraItems = "org.kde.plasma.battery,org.kde.plasma.volume,org.kde.plasma.networkmanagement";
            shownItems = "org.kde.plasma.battery,org.kde.plasma.volume,org.kde.plasma.networkmanagement";
            hiddenItems = "";
            disabledStatusNotifiers = sniOverflow;
          };
        }

        {
          name = "org.kde.plasma.digitalclock";
          config.Appearance = {
            use24hFormat     = "2";
            showSeconds      = "2";
            showDate         = "true";
            dateFormat       = "custom";
            customDateFormat = "d/M/yyyy";
            autoFontAndSize  = "false";
            fontFamily       = "Roboto Flex";
            fontWeight       = "400";
            boldText         = "false";
            italicText       = "false";
            fontSize         = "9";
          };
        }

        # Thin show-desktop strip at the right edge, mirrors the Win11
        # invisible-strip behaviour. Click is wired to Meta+D below.
        { name = "org.kde.plasma.panelspacer"; config.General = { expanding = "false"; length = "6"; }; }
      ];
    }];

    shortcuts = {
      "services/org.kde.dolphin.desktop"."_launch"              = "Meta+E";
      "services/org.kde.krunner.desktop"."_launch"              = [ "Meta+R" "Meta+S" ];
      "services/systemsettings.desktop"."_launch"               = "Meta+I";
      "services/org.kde.spectacle.desktop"."_launch"            = "Meta+Shift+S";
      "services/org.kde.plasma-systemmonitor.desktop"."_launch" = "Ctrl+Shift+Escape";

      "kwin"."Show Desktop"             = "Meta+D";
      "kwin"."Window Maximize"          = "Meta+Up";
      "kwin"."Window Minimize"          = "Meta+Down";
      "kwin"."Window Quick Tile Left"   = "Meta+Left";
      "kwin"."Window Quick Tile Right"  = "Meta+Right";
      "kwin"."Overview"                 = "none";
      "kwin"."Walk Through Windows"     = "Alt+Tab";

      "ksmserver"."Lock Session" = [ "Meta+L" "Screensaver" ];

      "plasmashell"."show emoji selector" = "Meta+.";
      "plasmashell"."manage activities"   = "Meta+Q";
      "plasmashell"."clipboard_action"    = "Meta+V";

      "kwin"."Switch One Desktop to the Left"  = "Meta+Ctrl+Left";
      "kwin"."Switch One Desktop to the Right" = "Meta+Ctrl+Right";
      "kwin"."Add Virtual Desktop"             = "Meta+Ctrl+D";
      "kwin"."Remove Virtual Desktop"          = "Meta+Ctrl+F4";

      "kded6"."display" = "Meta+P";
    };

    # The systemtray containment ids are generated at first run, so the
    # battery applet's showPercentage flag is set lazily at session start.
    startup.startupScript."battery-percentage" = {
      runAlways = true;
      restartServices = [ "plasma-plasmashell" ];
      text = ''
        cfg="$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc"
        [ -f "$cfg" ] || exit 0
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
    };

    configFile = {
      # plasma-manager's shortcut writer leaves the user-visible name field
      # empty, which Plasma 6.6 needs to actually dispatch the keypress for
      # Grid View. Writing the full triplet directly.
      kglobalshortcutsrc."kwin"."Grid View" = "Meta+Tab,Meta+Tab,Toggle Grid View";

      kdeglobals."General" = {
        AccentColor          = rgb roles.accent;
        font                 = "Roboto Flex,11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
        menuFont             = "Roboto Flex,11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
        toolBarFont          = "Roboto Flex,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
        smallestReadableFont = "Roboto Flex,9,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
        fixed                = "DejaVu Sans Mono,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,0";
      };
      kdeglobals."KDE" = {
        SingleClick = false;
        AnimationDurationFactor = 0.5;
      };
      kdeglobals."WM"."activeFont" = "Roboto Flex,11,-1,5,500,0,0,0,0,0,0,0,0,0,0,1";

      # Power: AC locks only; battery sleeps after 15min and locks.
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

      kscreenlockerrc.Daemon = {
        Autolock     = true;
        LockOnResume = true;
        Timeout      = 30;
      };
      kscreenlockerrc.Greeter.WallpaperPlugin = "org.kde.color";
      kscreenlockerrc."Greeter/Wallpaper/org.kde.color/General".Color = rgb roles.lockscreen;

      # Plasma exports LANG from this file into the session env at login;
      # a stale en_US entry left over from System Settings was making the
      # lockscreen greeter render 12h despite the system locale being en_GB.
      plasma-localerc.Formats = {
        LANG = "en_GB.UTF-8";
        useDetailed = true;
      };
    };
  };
}

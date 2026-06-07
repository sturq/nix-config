{ ... }: {
  programs.plasma.shortcuts = {
    "services/org.kde.dolphin.desktop"."_launch"              = "Meta+E";
    "services/org.kde.krunner.desktop"."_launch"              = [ "Meta+R" "Meta+S" ];
    "services/systemsettings.desktop"."_launch"               = "Meta+I";
    "services/org.kde.spectacle.desktop"."_launch"            = "Meta+Shift+S";
    "services/org.kde.plasma-systemmonitor.desktop"."_launch" = "Ctrl+Shift+Escape";

    # Win11-style snap layout (one-shot tile, no chain — KWin 6.6's
    # built-in Quick Tile Bottom always wins Meta+Down at startup and
    # there's no clean way to layer a "tile then minimise" chain on top
    # without forking KWin).
    "kwin"."Show Desktop"             = "Meta+D";
    "kwin"."Window Maximize"          = "Meta+Up";
    "kwin"."Window Quick Tile Bottom" = "Meta+Down";
    "kwin"."Window Quick Tile Left"   = "Meta+Left";
    "kwin"."Window Quick Tile Right"  = "Meta+Right";
    "kwin"."Window Minimize"          = "none";

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

  # Meta+Tab = Win11 Task View. Overview shows windows tiled + the
  # virtual-desktop strip across the top (vs. Grid View which is only the
  # desktops). Grid View moves to Meta+G (its baked-in default).
  programs.plasma.configFile.kglobalshortcutsrc.kwin = {
    "Overview"                       = "Meta+Tab,Meta+W,Toggle Overview";
    "Grid View"                      = "Meta+G,Meta+G,Toggle Grid View";
    "Walk Through Windows"           = "Alt+Tab,Alt+Tab,Walk Through Windows";
    "Walk Through Windows (Reverse)" = "Alt+Shift+Tab,Alt+Shift+Tab,Walk Through Windows (Reverse)";
  };
}

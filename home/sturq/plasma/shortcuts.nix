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

  # Meta+Tab = Grid View (virtual desktop manager — all desktops
  # side-by-side with draggable window thumbnails). Written as a full
  # triplet because plasma-manager's shortcuts API only writes the
  # active key; KWin's baked-in defaults for "Walk Through Windows"
  # include both Alt+Tab AND Meta+Tab, and KGlobalAccel resolves the
  # collision in TabBox's favour at session start. Overriding the
  # `defaults` field too is what actually frees Meta+Tab.
  programs.plasma.configFile.kglobalshortcutsrc.kwin = {
    "Grid View"                      = "Meta+Tab,Meta+Tab,Toggle Grid View";
    "Walk Through Windows"           = "Alt+Tab,Alt+Tab,Walk Through Windows";
    "Walk Through Windows (Reverse)" = "Alt+Shift+Tab,Alt+Shift+Tab,Walk Through Windows (Reverse)";
  };
}

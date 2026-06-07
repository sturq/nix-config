{ ... }: {
  programs.plasma.shortcuts = {
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

  # plasma-manager's shortcut writer leaves the user-visible name field
  # empty, which Plasma 6.6 needs to actually dispatch the keypress for
  # Grid View. Writing the full triplet directly.
  programs.plasma.configFile.kglobalshortcutsrc."kwin"."Grid View" =
    "Meta+Tab,Meta+Tab,Toggle Grid View";
}

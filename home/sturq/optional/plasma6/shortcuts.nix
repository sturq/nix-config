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

  # Win11 Task View parity: Meta+Tab opens the Grid View overview (all
  # virtual desktops side-by-side with draggable window thumbnails).
  #
  # plasma-manager's shortcuts API only writes the active key; KWin's
  # baked-in defaults for "Walk Through Windows" include BOTH Alt+Tab
  # *and* Meta+Tab, and KGlobalAccel resolves the collision in TabBox's
  # favour because it registers first at session start. The fix is to
  # rewrite kglobalshortcutsrc directly with the full triplet, including
  # an overridden defaults field that drops Meta+Tab from the TabBox
  # walker. Format: "current_key,default_keys,friendly_name".
  programs.plasma.configFile.kglobalshortcutsrc.kwin = {
    "Grid View"                     = "Meta+Tab,Meta+Tab,Toggle Grid View";
    "Walk Through Windows"          = "Alt+Tab,Alt+Tab,Walk Through Windows";
    "Walk Through Windows (Reverse)" = "Alt+Shift+Tab,Alt+Shift+Tab,Walk Through Windows (Reverse)";
  };
}

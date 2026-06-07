{ ... }: {
  programs.plasma.shortcuts = {
    "services/org.kde.dolphin.desktop"."_launch"              = "Meta+E";
    "services/org.kde.krunner.desktop"."_launch"              = [ "Meta+R" "Meta+S" ];
    "services/systemsettings.desktop"."_launch"               = "Meta+I";
    "services/org.kde.spectacle.desktop"."_launch"            = "Meta+Shift+S";
    "services/org.kde.plasma-systemmonitor.desktop"."_launch" = "Ctrl+Shift+Escape";

    # Win11-style snap layout: Up = maximize, Left/Right = tile left/right.
    # Meta+Down is handled by the win11-meta-down KWin script (chains
    # tile-bottom → minimise on second press, like Win11) — see
    # kwin-scripts.nix. The built-in Window Quick Tile Bottom shortcut
    # is unset so it doesn't double-fire on the same key.
    "kwin"."Show Desktop"             = "Meta+D";
    "kwin"."Window Maximize"          = "Meta+Up";
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

  # Meta+Tab = Win11 Task View. Plasma's "Overview" effect (windows
  # tiled on the current desktop + a virtual-desktop strip across the
  # top) matches the Win11 feel better than plain Grid View (which only
  # shows the desktops). Grid View moves to Meta+G (its baked-in default).
  #
  # plasma-manager's shortcuts API only writes the active key; KWin's
  # baked-in defaults for Walk Through Windows include both Alt+Tab AND
  # Meta+Tab, so KGlobalAccel resolves the collision in TabBox's favour
  # unless we strip Meta+Tab from the default field directly. Format:
  # "current_key,default_keys,friendly_name".
  programs.plasma.configFile.kglobalshortcutsrc = {
    kwin = {
      "Overview"                       = "Meta+Tab,Meta+W,Toggle Overview";
      "Grid View"                      = "Meta+G,Meta+G,Toggle Grid View";
      "Walk Through Windows"           = "Alt+Tab,Alt+Tab,Walk Through Windows";
      "Walk Through Windows (Reverse)" = "Alt+Shift+Tab,Alt+Shift+Tab,Walk Through Windows (Reverse)";

      # Free Meta+Down from the built-in Quick Tile so the win11-meta-down
      # KWin script can grab it; the script chains tile-bottom → minimise
      # on second press (see kwin-scripts.nix).
      "Window Quick Tile Bottom"       = "none,none,Quick Tile Window to the Bottom";
    };

    # The script lives in its own component because KWin scripts register
    # their shortcuts under the script's plugin id.
    win11-meta-down."Win11-style Meta+Down (tile / minimise)" =
      "Meta+Down,none,Win11-style Meta+Down (tile / minimise)";
  };
}

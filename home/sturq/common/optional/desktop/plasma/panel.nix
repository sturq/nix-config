{ ... }:

let
  # Built-in plasmoids that ship a tray icon by default but we don't want
  # to see — listed once and routed straight to the overflow popup.
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
  # Bottom panel laid out Win11-style: kickoff + tasks centred between two
  # expanding spacers; the status cluster pinned to the right uses two
  # systemtrays so the overflow arrow ends up on the LEFT of the icons.
  programs.plasma.panels = [{
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

      # Thin show-desktop strip at the right edge — Win11-style invisible
      # button. The stock org.kde.plasma.showdesktop applet always
      # renders a visible "user-desktop" icon; this is a minimal custom
      # plasmoid (declared via home.file in default.nix) that draws
      # nothing but forwards clicks to KWin's Show Desktop action.
      "sturq.invisible-showdesktop"
    ];
  }];

  # The systemtray containment ids are generated at first run, so the
  # battery applet's showPercentage flag is set lazily at session start.
  programs.plasma.startup.startupScript."battery-percentage" = {
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
}

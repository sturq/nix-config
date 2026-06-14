{ lib, ... }:

let
  palette = lib.palette;
  rgb = palette.hexToRgb;
in {
  programs.plasma.configFile = {
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
      Autolock     = false;
      LockOnResume = false;
      Timeout      = 30;
    };
    kscreenlockerrc.Greeter.WallpaperPlugin = "org.kde.color";
    kscreenlockerrc."Greeter/Wallpaper/org.kde.color/General".Color =
      rgb palette.roles.lockscreen;
  };
}

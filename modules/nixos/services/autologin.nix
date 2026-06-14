{ ... }: {
  # Skip SDDM greeter, boot straight into the sturq session. Pair with
  # kscreenlockerrc.Daemon.Autolock=false in the user plasma config to
  # keep the session unlocked for remote ops.
  services.displayManager.autoLogin = {
    enable = true;
    user = "sturq";
  };
}

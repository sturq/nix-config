{ ... }: {
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = false;
    # gamescope session: composited Wayland micro-compositor for games;
    # appears as its own SDDM session entry so you can log straight into
    # Big Picture for HDR/VRR/scaling that Plasma's compositor can't do.
    gamescopeSession.enable = true;
  };

  # gamemode: CPU governor → performance, IO priority bump, GPU clock
  # tweaks while a game is in foreground. Steam launches games with
  # `gamemoderun %command%` to opt them in (or set globally via
  # steam-config-nix later).
  programs.gamemode = {
    enable = true;
    enableRenice = true;
  };
}

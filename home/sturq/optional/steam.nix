{ pkgs, lib, ... }:

# Home-level Steam settings enforcement. Steam doesn't expose its UI
# preferences anywhere except VDF files inside ~/.local/share/Steam,
# which it rewrites from Steam Cloud on every launch. The only way
# pros-on-NixOS make these stick is the steam-config-nix pattern:
#   1. Python with the `vdf` library to read/merge/write the files
#   2. Patch only when Steam is closed (writes get clobbered otherwise)
#   3. .desktop override so the patcher runs before each launch as well
#      as on every home-manager switch.
#
# Some keys (community-content, in-game overlay privacy) live under
# undocumented localconfig.vdf paths — we set the ones with verified
# names; the rest still need a one-time click in Steam's UI.

let
  vdfPython = pkgs.python3.withPackages (ps: [ ps.vdf ]);

  patcher = pkgs.writeText "steam-vdf-patcher.py" ''
    #!/usr/bin/env python3
    """Idempotent Steam VDF patcher. Run only when Steam is closed."""
    import os, glob, sys, vdf

    HOME = os.path.expanduser("~")
    STEAM = f"{HOME}/.local/share/Steam"

    def patch(path, mutate):
        if not os.path.exists(path):
            return
        try:
            with open(path) as f:
                data = vdf.load(f)
        except Exception as e:
            print(f"skip {path}: {e}", file=sys.stderr)
            return
        mutate(data)
        with open(path, "w") as f:
            vdf.dump(data, f, pretty=True)
        print(f"patched {path}")

    def setdeep(d, path, value):
        for k in path[:-1]:
            d = d.setdefault(k, {})
        d[path[-1]] = value

    # --- global: config.vdf (bandwidth + downloads-during-gameplay)
    def global_cfg(d):
        # InstallConfigStore.Software.Valve.Steam.<key>
        base = ["InstallConfigStore", "Software", "Valve", "Steam"]
        setdeep(d, base + ["DownloadThrottleKbps"], "256")        # ~256 kB/s
        setdeep(d, base + ["AllowDownloadsDuringGameplay"], "0")  # off
    patch(f"{STEAM}/config/config.vdf", global_cfg)

    # --- per-user: sharedconfig + localconfig under userdata/<SteamID>/
    for cfg_dir in glob.glob(f"{STEAM}/userdata/*/config"):
        # sharedconfig.vdf: startup window → Library (#app_games)
        def shared(d):
            setdeep(d, ["UserLocalConfigStore", "SteamDefaultDialog"], "#app_games")
        patch(f"{cfg_dir}/sharedconfig.vdf", shared)

        # localconfig.vdf: GPU/CPU + community knobs
        def local(d):
            sys_ = ["UserLocalConfigStore", "system"]
            setdeep(d, sys_ + ["EnableGPUAcceleratedRendering"], "0")
            setdeep(d, sys_ + ["ReduceClientUpdateRateWhenLocked"], "1")
            # Privacy: drop the various "show me recommended/community" knobs
            news = ["UserLocalConfigStore", "News"]
            setdeep(d, news + ["NotifyAvailableGames"], "0")
            store = ["UserLocalConfigStore", "Web", "PreferredStore"]
            setdeep(d, store, "0")
        patch(f"{cfg_dir}/localconfig.vdf", local)

    print("steam-vdf-patcher done")
  '';

  patchScript = pkgs.writeShellScript "steam-patch-if-closed" ''
    if pgrep -x steam >/dev/null 2>&1 || pgrep -x steam.sh >/dev/null 2>&1; then
      echo "steam running — skipping VDF patch"
      exit 0
    fi
    ${vdfPython}/bin/python ${patcher} || true
  '';

  # Steam launch wrapper: patch first, then exec the real binary.
  steamWrapper = pkgs.writeShellScript "steam-wrapped" ''
    ${vdfPython}/bin/python ${patcher} || true
    exec ${pkgs.steam}/bin/steam "$@"
  '';
in {
  # 1. Patch on every home-manager activation (only fires if Steam closed).
  home.activation.steamSettings =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run ${patchScript}
    '';

  # 2. .desktop override so a fresh Steam launch re-patches first. Plasma's
  # launcher reads from XDG_DATA_DIRS; ~/.local/share/applications takes
  # priority over /run/current-system/sw/share/applications, so our entry
  # shadows the upstream one.
  xdg.desktopEntries.steam = {
    name = "Steam";
    comment = "Application for managing and playing games on Steam (settings auto-enforced)";
    exec = "${steamWrapper} %U";
    icon = "steam";
    terminal = false;
    type = "Application";
    categories = [ "Network" "FileTransfer" "Game" ];
    mimeType = [ "x-scheme-handler/steam" "x-scheme-handler/steamlink" ];
    settings = {
      StartupWMClass = "Steam";
      PrefersNonDefaultGPU = "true";
      X-KDE-RunOnDiscreteGpu = "true";
    };
  };
}

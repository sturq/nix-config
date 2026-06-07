{ ... }:

let
  # Win11-style Meta+Down: first press snaps the active window to the
  # bottom half (or restores from maximize); second press minimises.
  # KWin's built-in Quick Tile is single-shot, so we ship a tiny KWin
  # script that inspects state and chains.
  win11MetaDown = {
    metadata = builtins.toJSON {
      KPackageStructure = "KWin/Script";
      KPlugin = {
        Id = "win11-meta-down";
        Name = "Win11 Meta+Down chain";
        Description = "First press tiles to the bottom (or restores from maximised). Second press minimises, like Windows 11.";
        Authors = [ { Name = "sturq"; } ];
        Version = "1.0";
        License = "MIT";
      };
      "X-Plasma-API" = "javascript";
      "X-Plasma-MainScript" = "code/main.js";
    };

    main = ''
      // Track the window we last snapped. Second Meta+Down on the SAME
      // window → minimise. Anything else → tile bottom half.
      let lastSnapped = null;

      print("win11-meta-down: script loaded");

      registerShortcut(
        "win11-meta-down",
        "Win11-style Meta+Down (tile / minimise)",
        "Meta+Down",
        function() {
          const w = workspace.activeWindow;
          print("win11-meta-down: fired, active =", w ? w.caption : "null");
          if (!w || w.minimized) return;

          const sameWindow = lastSnapped === w.internalId;
          const alreadyTiled =
            (w.maximizeMode && w.maximizeMode !== 0) ||
            (w.quickTileMode && w.quickTileMode !== 0);

          print("win11-meta-down: sameWindow=" + sameWindow + " alreadyTiled=" + alreadyTiled);

          if (sameWindow || alreadyTiled) {
            print("win11-meta-down: → minimize");
            w.minimized = true;
            lastSnapped = null;
            return;
          }

          print("win11-meta-down: → tile bottom");
          w.setMaximize(false, false);  // un-maximize first if needed
          workspace.slotWindowQuickTileBottom();
          lastSnapped = w.internalId;
        }
      );
    '';
  };
in {
  home.file = {
    ".local/share/kwin/scripts/win11-meta-down/metadata.json".text = win11MetaDown.metadata;
    ".local/share/kwin/scripts/win11-meta-down/contents/code/main.js".text = win11MetaDown.main;
  };

  # KWin only loads scripts whose Plugin entry is enabled in kwinrc.
  programs.plasma.configFile.kwinrc.Plugins."win11-meta-downEnabled" = true;
}

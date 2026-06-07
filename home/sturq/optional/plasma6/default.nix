{ pkgs, ... }: {
  # KDE Plasma 6 (user-level). Theme + panel + shortcuts + session split
  # across siblings so each file is a single concern. Konsole keeps its
  # own file because the colourscheme generation has no overlap with the
  # plasma-manager surface.
  imports = [
    ./theme.nix
    ./panel.nix
    ./shortcuts.nix
    ./session.nix
    ./konsole.nix
  ];

  programs.plasma.enable = true;

  # Tiny custom plasmoid: an invisible click target that fires KWin's
  # "Show Desktop" shortcut. Used in panel.nix as the right-edge strip.
  # Packaged as a single derivation so the whole plasmoid directory is
  # one symlink — plasmashell rejects per-file home.file symlinks with
  # "path traversal attempt" because each file resolves to a different
  # /nix/store path outside the plasmoid dir.
  home.file.".local/share/plasma/plasmoids/sturq.invisible-showdesktop".source =
    let
      metadata = builtins.toJSON {
        KPackageStructure = "Plasma/Applet";
        KPlugin = {
          Id = "sturq.invisible-showdesktop";
          Name = "Invisible Show Desktop";
          Description = "Empty click target that triggers Show Desktop";
          Authors = [ { Name = "sturq"; } ];
          Version = "1.0";
          License = "MIT";
        };
        X-Plasma-API-Minimum-Version = "6.0";
      };
      mainQml = ''
        import QtQuick
        import QtQuick.Layouts
        import org.kde.plasma.plasmoid
        import org.kde.plasma.plasma5support as P5Support

        PlasmoidItem {
            // The panel renders compactRepresentation (and falls back
            // to Plasmoid.icon if none is given — that's the yellow
            // moon we were seeing). Provide an empty MouseArea instead.
            toolTipMainText: ""
            toolTipSubText: ""

            P5Support.DataSource {
                id: shell
                engine: "executable"
                connectedSources: []
                onNewData: (sourceName) => disconnectSource(sourceName)
                function exec(cmd) { connectSource(cmd); }
            }

            compactRepresentation: MouseArea {
                Layout.minimumWidth: 6
                Layout.maximumWidth: 6
                Layout.fillHeight: true
                acceptedButtons: Qt.LeftButton
                onClicked: shell.exec(
                    "qdbus6 org.kde.kglobalaccel /component/kwin invokeShortcut 'Show Desktop'"
                )
            }
        }
      '';
    in pkgs.runCommand "sturq-invisible-showdesktop" { } ''
      mkdir -p $out/contents/ui
      cat > $out/metadata.json <<'EOF'
      ${metadata}
      EOF
      cat > $out/contents/ui/main.qml <<'EOF'
      ${mainQml}
      EOF
    '';

  home.packages = with pkgs; [
    firefox
    keepassxc
    yazi
    helix
    zathura
    mpv
    imv
    ventoy-full   # write multi-ISO USB sticks (GUI)
  ];
}

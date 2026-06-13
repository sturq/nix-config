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
    ./perf.nix
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
            toolTipMainText: ""
            toolTipSubText: ""

            // DataSource has to live INSIDE compactRepresentation —
            // compactRepresentation is its own Component scope and can't
            // reach ids declared on the PlasmoidItem root, so a shell
            // declared up here would resolve to undefined when the
            // MouseArea handler fires (silent JS error, click looks dead).
            compactRepresentation: MouseArea {
                Layout.minimumWidth: 12
                Layout.maximumWidth: 12
                Layout.fillHeight: true
                acceptedButtons: Qt.LeftButton
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                P5Support.DataSource {
                    id: shell
                    engine: "executable"
                    connectedSources: []
                    onNewData: (sourceName) => disconnectSource(sourceName)
                    function exec(cmd) { connectSource(cmd); }
                }

                onClicked: shell.exec(
                    "qdbus6 org.kde.KWin /KWin showDesktop true"
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
    keepassxc
  ];
}

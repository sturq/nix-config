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
  home.file = {
    ".local/share/plasma/plasmoids/sturq.invisible-showdesktop/metadata.json".text =
      builtins.toJSON {
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

    ".local/share/plasma/plasmoids/sturq.invisible-showdesktop/contents/ui/main.qml".text = ''
      import QtQuick
      import QtQuick.Layouts
      import org.kde.plasma.plasmoid
      import org.kde.plasma.plasma5support as P5Support

      PlasmoidItem {
          Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation
          Plasmoid.constraintHints: Plasmoid.CanFillArea

          P5Support.DataSource {
              id: shell
              engine: "executable"
              connectedSources: []
              onNewData: (sourceName) => disconnectSource(sourceName)
              function exec(cmd) { connectSource(cmd); }
          }

          fullRepresentation: MouseArea {
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
  };

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

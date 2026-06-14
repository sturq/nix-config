{ pkgs, ... }: {
  # Drop KDE defaults we don't want. Bare desktop — add apps back
  # explicitly via hosts/common/optional/applications when needed.
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    discover         # app store — pointless on NixOS
    elisa            # music player
    khelpcenter      # help docs
    oxygen           # legacy theme
    plasma-browser-integration
    kate             # editor
    kcalc            # calculator
    kwalletmanager   # wallet UI
    okular           # PDF viewer
    ark              # archive tool
    gwenview         # image viewer
    kfind            # search
    kcharselect      # char picker
    print-manager    # printer settings panel
    kmenuedit        # menu editor
  ];
}

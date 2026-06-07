{ pkgs, lib, ... }: {
  imports = [ ./config.nix ./konsole.nix ];

  # User-level Plasma 6 config: just apps. Everything else (theme, panel,
  # shortcuts, kdeglobals, lockscreen, power) lives in ./config.nix.

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

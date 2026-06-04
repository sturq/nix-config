{ pkgs, ... }: {
  imports = [
    ./sway.nix
    ./waybar.nix
  ];

  # Desktop applications (user-level via home-manager).
  # Suckless-spirit picks: minimal, vim-keys where possible, Wayland-native.
  home.packages = with pkgs; [
    firefox          # browser (no realistic minimal alternative for daily use)
    keepassxc        # password manager
    yazi             # terminal file manager (vim-keys, fast)
    helix            # modal editor (single binary, sane defaults)
    zathura          # PDF viewer (minimal, vim-keys)
    mpv              # video player (suckless-spirit, scriptable)
    imv              # image viewer (Wayland-native, vim-keys)
    pavucontrol      # audio mixer GUI
  ];
}

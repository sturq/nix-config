{ pkgs, ... }: {
  home.packages = with pkgs; [
    claude-code
    fastfetch    # neofetch successor — system info on shell open
    htop         # classic process viewer
    btop         # modern fancy process viewer
  ];
}

{ pkgs, ... }: {
  # macOS variant — CLI works; GTK/GNOME don't apply.
  imports = [ ../features/cli ];

  home.username = "sturq";
  home.homeDirectory = "/Users/sturq";

  # macOS-only packages:
  # home.packages = with pkgs; [ mas ];
}

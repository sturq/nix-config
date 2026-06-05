{ pkgs, ... }: {
  # macOS variant — CLI works; GTK/GNOME don't apply.
  imports = [ ../../modules/home/cli ];

  home.username = "sturq";
  home.homeDirectory = "/Users/sturq";

  # macOS-only packages:
  # home.packages = with pkgs; [ mas ];
}

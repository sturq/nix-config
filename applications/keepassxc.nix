{ pkgs, ... }: {
  # KeePassXC — password manager. Installed at the system level so
  # KDE's launcher / Dolphin / xdg-mime see it as a real app.
  environment.systemPackages = [ pkgs.keepassxc ];
}

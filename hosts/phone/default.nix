{ pkgs, ... }: {
  # nix-on-droid host: runs in PRoot inside Termux on Android.
  # No system services, no systemd. Just packages + home-manager.

  environment.packages = with pkgs; [
    # Android-side tooling — duplicates what cli.nix gives the user,
    # but at the system level for shell-on-startup convenience.
    git
    openssh
    age
    ssh-to-age
    ripgrep
    fd
    htop
  ];

  # User-level config (analog to home-manager.users.X on NixOS).
  home-manager.config = { ... }: {
    imports = [
      ../../home/features/cli
    ];

    home.username = "nix-on-droid";
    home.homeDirectory = "/data/data/com.termux.nix/files/home";
  };

  # NoD has its own stateVersion option separate from NixOS
  system.stateVersion = "25.05";
}

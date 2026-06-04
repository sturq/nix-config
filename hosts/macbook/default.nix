{ pkgs, ... }: {
  # nix-darwin host (works for both Apple Silicon and Intel Macs —
  # arch is selected by which darwinConfiguration entry in flake.nix
  # points here: `macbook` (aarch64-darwin) or `macbook-intel` (x86_64-darwin)).

  # Required for nix-darwin
  system.stateVersion = 5;

  # Use Nix daemon
  services.nix-daemon.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # User
  users.users.sturq.home = "/Users/sturq";

  # Touch ID for sudo (Apple Silicon)
  security.pam.services.sudo_local.touchIdAuth = true;

  # macOS defaults — opinionated tweaks
  system.defaults = {
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      InitialKeyRepeat = 14;
      KeyRepeat = 1;
    };
    dock = {
      autohide = true;
      orientation = "left";
      mineffect = "scale";
      show-recents = false;
    };
    finder = {
      AppleShowAllFiles = true;
      ShowPathbar = true;
      FXEnableExtensionChangeWarning = false;
    };
    screencapture = {
      location = "~/Pictures/Screenshots";
      type = "png";
    };
  };

  # Homebrew for Mac App Store / casks that aren't in nixpkgs
  homebrew = {
    enable = false;  # turn on if you want GUI apps Nix can't build (e.g. Adobe)
    # casks = [ "firefox" "iterm2" ];
  };
}

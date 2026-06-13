{ ... }: {
  # nix-darwin host. arch picked by which darwinConfiguration in
  # flake.nix points here: macbook (aarch64) or macbook-intel (x86_64).

  system.stateVersion = 5;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  users.users.sturq.home = "/Users/sturq";

  # Touch ID for sudo (Apple Silicon).
  security.pam.services.sudo_local.touchIdAuth = true;

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
}

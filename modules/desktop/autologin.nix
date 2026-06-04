{ ... }: {
  # Optional: SDDM autologin straight into Plasma for the sturq user.
  # Remove this import for prod hosts; the regular SDDM greeter takes over.
  services.displayManager = {
    autoLogin = {
      enable = true;
      user = "sturq";
    };
  };
}

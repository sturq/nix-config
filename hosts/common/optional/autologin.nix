{ ... }: {
  # Skip the SDDM greeter — handy on dev boxes that boot straight into
  # a known user. Hosts that don't want this just don't import the file.
  services.displayManager.autoLogin = {
    enable = true;
    user = "sturq";
  };
}

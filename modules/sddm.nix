{ ... }: {
  # SDDM — the Plasma 6 login greeter. Wayland enabled so the Plasma
  # session runs on Wayland from sign-in.
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
}

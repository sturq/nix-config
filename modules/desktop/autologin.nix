{ ... }: {
  # Optional: skip tuigreet, drop sturq straight into sway on boot.
  # Useful for dev / VM hosts. Remove the import for prod.
  services.greetd.settings.initial_session = {
    command = "sway";
    user = "sturq";
  };
}

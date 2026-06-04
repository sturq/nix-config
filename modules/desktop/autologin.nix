{ ... }: {
  # Optional: bypass tuigreet, drop sturq straight into dwl on boot.
  # Useful for VMs / test machines. Remove the import for prod.
  services.greetd.settings.initial_session = {
    command = "dwl-start";
    user = "sturq";
  };
}

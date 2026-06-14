{ ... }: {
  # Geo-located timezone via GeoClue → systemd-timedated.
  services.geoclue2.enable = true;
  services.automatic-timezoned.enable = true;
}

{ ... }: {
  # PipeWire with ALSA + PulseAudio shims. Without rtkit PW logs a
  # flood of "RTKit error: ServiceUnknown" at session start.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true;
}

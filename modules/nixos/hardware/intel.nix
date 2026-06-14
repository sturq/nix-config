{ ... }: {
  # Intel-specific quirks shared across Intel Linux hosts. Pull this in
  # from hp250 / vivobook-Intel / hp250-equivalents alongside the
  # nixos-hardware common-cpu-intel / common-gpu-intel modules.

  # Force legacy snd_hda_intel driver instead of Sound Open Firmware on
  # Intel chipsets that ship SOF-capable codecs but no matching firmware
  # topology — Alder Lake laptops (HP 250 G9 etc.) regress to "no
  # soundcards" if SOF can't finish init. dsp_driver=1 == HDA-only.
  boot.extraModprobeConfig = ''
    options snd-intel-dspcfg dsp_driver=1
  '';
}

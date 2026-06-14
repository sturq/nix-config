{ pkgs, ... }: {
  # Intel-specific quirks shared across Intel Linux hosts. Pull this in
  # from hp250 etc. alongside the nixos-hardware common-cpu-intel /
  # common-gpu-intel modules.

  # Sound Open Firmware for Alder Lake codec init.
  hardware.firmware = [ pkgs.sof-firmware ];

  # snd_soc_avs claims the audio controller first on modern kernels
  # ("Digital mics found on Skylake+ ... using SOF driver"), but
  # then the SOF machine driver never finishes binding, so
  # /proc/asound/cards stays empty. Blacklisting avs and forcing
  # dsp_driver=4 (SOF-only) lets sof-audio-pci-intel-tgl claim the
  # device cleanly.
  boot.blacklistedKernelModules = [ "snd_soc_avs" ];
  boot.extraModprobeConfig = ''
    options snd-intel-dspcfg dsp_driver=4
  '';
}

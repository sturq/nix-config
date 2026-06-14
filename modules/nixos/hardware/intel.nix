{ pkgs, ... }: {
  # Intel-specific quirks shared across Intel Linux hosts. Pull this in
  # from hp250 etc. alongside the nixos-hardware common-cpu-intel /
  # common-gpu-intel modules.

  # Sound Open Firmware for Alder Lake codec init.
  hardware.firmware = [
    pkgs.sof-firmware
    pkgs.alsa-ucm-conf       # Use Case Manager profiles SOF machine drivers expect
  ];

  # Force snd-intel-dspcfg to take the SOF path. dsp_driver=4 is
  # "SOF only" — without the force, modern Alder Lake silicon ships
  # with snd_soc_avs claiming the device first ("Digital mics found
  # on Skylake+ platform, using SOF driver"), but the codec machine
  # driver never finishes binding because avs got in the way.
  boot.extraModprobeConfig = ''
    options snd-intel-dspcfg dsp_driver=4
    blacklist snd_soc_avs
  '';
}

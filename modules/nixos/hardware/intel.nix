{ pkgs, ... }: {
  # Intel-specific quirks shared across Intel Linux hosts. Pull this in
  # from hp250 etc. alongside the nixos-hardware common-cpu-intel /
  # common-gpu-intel modules.

  # Sound Open Firmware for Alder Lake codec init.
  hardware.firmware = [ pkgs.sof-firmware ];

  # Force SOF driver via kernel cmdline (more reliable than modprobe.d —
  # snd-intel-dspcfg gets pulled in early during initrd and may miss
  # late-loaded modprobe options). dsp_driver=4 = SOF.
  boot.kernelParams = [
    "snd-intel-dspcfg.dsp_driver=4"
    "module_blacklist=snd_soc_avs"  # avs grabs 1f.3 first, blocks SOF binding
  ];
}

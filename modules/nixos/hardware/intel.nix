{ pkgs, ... }: {
  # Intel-specific quirks shared across Intel Linux hosts. Pull this in
  # from hp250 etc. alongside the nixos-hardware common-cpu-intel /
  # common-gpu-intel modules.

  # Sound Open Firmware: Alder Lake (12th gen Intel) ships an SOF-only
  # audio codec on PCH HDA bus — the legacy snd_hda_intel path finds the
  # controller but no codec, resulting in "no soundcards". Loading the
  # sof-firmware package and letting snd-intel-dspcfg auto-pick the SOF
  # driver fixes it.
  hardware.firmware = [ pkgs.sof-firmware ];
}

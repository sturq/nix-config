{ lib, ... }: {
  # Redistributable firmware blobs (CPU microcode, NIC, GPU, SOF audio)
  # + Intel + AMD CPU microcode updates. Same set the NixOS ISO ships.
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault true;
  hardware.cpu.amd.updateMicrocode   = lib.mkDefault true;
}

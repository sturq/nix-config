{ ... }: {
  # Linux on Apple hardware (Intel Macs running NixOS). Quirks the
  # mainline kernel can do but won't enable by default:
  #
  #   - applesmc: System Management Controller (temps + fan control)
  #   - mbpfan:   userspace daemon that drives the fan via applesmc, so
  #               idle MacBooks don't sit at max RPM
  #
  # T2-era machines (2018+) need additional firmware blobs and the
  # mbp-modules out-of-tree drivers — pull in
  # nixos-hardware.nixosModules.apple-t2 on those hosts (this file is
  # the pre-T2 baseline that works on MacBook 2,1 → MacBookPro 14,3).
  boot.kernelModules = [ "applesmc" "coretemp" ];
  services.mbpfan.enable = true;
}

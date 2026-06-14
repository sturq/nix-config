{ lib, ... }: {
  # Generic NixOS-on-Mac host — Linux on any Intel MacBook (pre-T2).
  # Same idea as the generic ./laptop, with the Apple hardware quirks
  # (mbpfan, applesmc) layered on top.
  imports = [
    ../laptop                                      # generic GUI laptop
    ../../modules/nixos/hardware/apple.nix          # mbpfan + applesmc
  ];

  networking.hostName = lib.mkForce "macbook";
}

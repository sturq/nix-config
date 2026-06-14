{ ... }: {
  imports = [
    ../../modules/base.nix
    ../../modules/grub.nix
    ../../modules/kernel.nix
    ../../modules/audio.nix
    ../../modules/fonts.nix
    ../../modules/kernel-tuning.nix
    ../../modules/stylix.nix
    ../../modules/dev-defaults.nix
    ../../modules/plasma6.nix
    ../../modules/sddm.nix
    ../../modules/keepassxc.nix
    ../../modules/tailscale.nix
    ../../modules/laptop.nix
  ];

  networking.hostName = "laptop";
  system.stateVersion = "25.11";
}

{ ... }: {
  imports = [
    ../../modules/base.nix
    ../../modules/boot/grub.nix
    ../../modules/kernel/latest.nix
    ../../modules/kernel/tuning.nix
    ../../modules/services/audio.nix
    ../../modules/services/dev-defaults.nix
    ../../modules/services/tailscale.nix
    ../../modules/theme/fonts.nix
    ../../modules/theme/stylix.nix
    ../../modules/desktop-environments/plasma6.nix
    ../../modules/login-managers/sddm.nix
    ../../modules/applications/keepassxc.nix
  ];

  networking.hostName = "desktop";
  system.stateVersion = "25.11";

  # ---- Desktop bits ---------------------------------------------------
  services.logind.settings.Login.IdleAction = "ignore";
  powerManagement.cpuFreqGovernor = "performance";
}

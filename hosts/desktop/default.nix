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
    ../../modules/desktop-environments/plasma6.nix
    ../../modules/login-managers/sddm.nix
    ../../modules/keepassxc.nix
    ../../modules/tailscale.nix
  ];

  networking.hostName = "desktop";
  system.stateVersion = "25.11";

  # ---- Desktop bits ---------------------------------------------------
  services.logind.settings.Login.IdleAction = "ignore";
  powerManagement.cpuFreqGovernor = "performance";
}

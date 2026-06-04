{ ... }: {
  # Generic desktop add-ons on top of the workstation profile. No battery,
  # no lid, no TLP — just performance defaults and wake-on-LAN headroom.
  imports = [
    ./workstation.nix
  ];

  # Plug-in tower: never auto-suspend, never blank too quickly.
  services.logind.settings.Login.IdleAction = "ignore";

  # Performance scheduler defaults — desktop has no power budget concerns.
  powerManagement.cpuFreqGovernor = "performance";
}

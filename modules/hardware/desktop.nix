{ ... }: {
  # Generic desktop bits: no lid, no idle, full performance governor.
  services.logind.settings.Login.IdleAction = "ignore";
  powerManagement.cpuFreqGovernor = "performance";
}

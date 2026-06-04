{ ... }: {
  # Opinionated desktop bits. No battery, no lid, full performance.
  services.logind.settings.Login.IdleAction = "ignore";
  powerManagement.cpuFreqGovernor = "performance";
}

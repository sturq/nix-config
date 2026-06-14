{ ... }: {
  # Conservative VM tuning. swappiness=10 keeps RAM hot, autogroup
  # keeps foreground apps responsive when something heavy runs in
  # the background.
  boot.kernel.sysctl = {
    "kernel.sched_autogroup_enabled" = 1;
    "vm.swappiness" = 10;
  };
}

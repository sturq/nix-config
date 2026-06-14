{ ... }: {
  # Defaults every dev-machine in this repo wants: SSH with passwords +
  # initial passwords for sturq and root. (allowUnfree lives in base.nix.)
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
    settings.PermitRootLogin = "yes";
  };

  users.users.sturq.initialPassword = "install";
  users.users.root.initialPassword = "install";
}

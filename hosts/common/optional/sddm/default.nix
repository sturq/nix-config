{ ... }: {
  # Aggregator for the SDDM + autologin layer.
  imports = [
    ./sddm.nix
    # ./autologin.nix    # opt-in per host that wants greeter-skip
  ];
}

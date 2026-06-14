{ ... }: {
  # Aggregator: pull every system-side Plasma file. Hosts importing
  # ../desktop-environment get the whole desktop layer + the user-side
  # via the HM module from ../desktop-environment/user.
  imports = [
    ./plasma6.nix
    ./audio.nix
    ./fonts.nix
    ./exclude-packages.nix
    ./baloo.nix
    ./kernel-tuning.nix
  ];
}

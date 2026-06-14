{ ... }: {
  # System-side Plasma 6 layer. User-side is home/sturq/features/desktop.
  imports = [
    ./plasma6.nix
    ./audio.nix
    ./fonts.nix
    ./exclude-packages.nix
    ./baloo.nix
    ./kernel-tuning.nix
  ];
}

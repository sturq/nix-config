{ lib, ... }: {
  # Generic BTRFS layout — ESP + BTRFS root with subvolumes + zstd compression.
  # No LUKS. Subvols: @root / @home / @nix / @snap / @swap (with swapfile).
  # Device defaults to /dev/sda; override per host:
  #   disko.devices.disk.main.device = "/dev/nvme0n1";   # NVMe
  #   disko.devices.disk.main.device = "/dev/vda";        # VM
  #   disko.devices.disk.main.device = "/dev/mmcblk0";    # eMMC / SD
  disko.devices.disk.main = {
    type = "disk";
    device = lib.mkDefault "/dev/sda";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          type = "EF00";
          size = "1G";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };
        root = {
          size = "100%";
          content = {
            type = "btrfs";
            extraArgs = [ "-L" "nixos" "-f" ];
            subvolumes = {
              "@root" = {
                mountpoint = "/";
                mountOptions = [ "compress=zstd" "noatime" ];
              };
              "@home" = {
                mountpoint = "/home";
                mountOptions = [ "compress=zstd" "noatime" ];
              };
              "@nix" = {
                mountpoint = "/nix";
                mountOptions = [ "compress=zstd" "noatime" ];
              };
              "@snap" = {
                mountpoint = "/.snapshots";
                mountOptions = [ "compress=zstd" "noatime" ];
              };
              "@swap" = {
                mountpoint = "/swap";
                swap.swapfile.size = "16G";
              };
            };
          };
        };
      };
    };
  };
}

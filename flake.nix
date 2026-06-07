{
  description = "sturq's NixOS configs (multi-host)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    # Declarative disk layouts (used by nixos-anywhere for fresh installs).
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # System-wide theming via base16 + wallpaper sampling.
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Declarative Plasma 6 configuration (panels, shortcuts, kdeglobals…).
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # Per-device hardware tuning (common-cpu-intel, common-gpu-amd, model
    # modules for specific Lenovo/HP/Asus/Framework laptops, etc.).
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    # Single source of truth for the sturq OLED palette. Plain data repo —
    # we treat it as raw source (flake = false) and parse formats/palette.json
    # ourselves in lib/palette.nix so the repo stays language-agnostic.
    sturq-palette = {
      url = "github:sturq/sturq-palette";
      flake = false;
    };

    # Cross-platform: macOS, Android, WSL
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-on-droid = {
      url = "github:nix-community/nix-on-droid";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-flatpak, disko, stylix,
              plasma-manager, nixos-hardware, nix-darwin, nix-on-droid,
              nixos-wsl, ... }@inputs:
    let
      # ---- Full NixOS host (Linux, KDE Plasma 6 Wayland desktop) ----
      # hwConfig: defaults to ./hosts/${hostName}/hardware-configuration.nix.
      # Pass an explicit path for hosts that share hardware with another host.
      mkHost = hostName: { hwConfig ? ./hosts/${hostName}/hardware-configuration.nix }: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/${hostName}
          hwConfig
          nix-flatpak.nixosModules.nix-flatpak
          stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ];
              users.sturq = import ./home/sturq/nixos.nix;
              backupFileExtension = "hm-backup";
            };
          }
        ];
      };

      # ---- Installer variant (Disko + nixos-anywhere) ----
      # Same as mkHost but swaps hardware-configuration for a generic disko
      # layout (1G ESP + 16G swap + ext4 root). Pass `device` for the target's
      # disk path (defaults to /dev/sda — overrides: nvme0n1, vda, mmcblk0…).
      # Deploy from any machine (even one running NixOS — kexec is used):
      #   nix run github:nix-community/nixos-anywhere -- --flake .#hp250-install root@<ip>
      mkInstaller = hostName: { device ? "/dev/sda" }: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/${hostName}
          ./modules/nixos/disko.nix
          { disko.devices.disk.main.device = device; }
          disko.nixosModules.disko
          nix-flatpak.nixosModules.nix-flatpak
          stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ];
              users.sturq = import ./home/sturq/nixos.nix;
              backupFileExtension = "hm-backup";
            };
          }
        ];
      };

      # ---- WSL host (NixOS-WSL, no GUI, CLI only) ----
      mkWsl = hostName: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/${hostName}
          nixos-wsl.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              users.sturq = import ./home/sturq/cli.nix;
              backupFileExtension = "hm-backup";
            };
          }
        ];
      };

      # ---- macOS host (nix-darwin) ----
      mkDarwin = hostName: system: nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/${hostName}
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              users.sturq = import ./home/sturq/darwin.nix;
              backupFileExtension = "hm-backup";
            };
          }
        ];
      };

      # ---- Android host (nix-on-droid) ----
      mkAndroid = hostName: nix-on-droid.lib.nixOnDroidConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-linux;
        modules = [
          ./hosts/${hostName}
        ];
        home-manager-path = home-manager.outPath;
        extraSpecialArgs = { inherit inputs; };
      };
    in {
      nixosConfigurations = {
        vm = mkHost "vm" {};
        vivobook = mkHost "vivobook" {};
        hp250 = mkHost "hp250" {};
        wsl = mkWsl "wsl";

        # ---- Generic profiles (deploy to any laptop/desktop on the fly) ----
        laptop = mkHost "laptop" {};
        desktop = mkHost "desktop" {};

        # ---- Installer variants (for nixos-anywhere + disko) ----
        hp250-install = mkInstaller "hp250" { device = "/dev/nvme0n1"; };
        vivobook-install = mkInstaller "vivobook" { device = "/dev/nvme0n1"; };
        vm-install = mkInstaller "vm" { device = "/dev/sda"; };  # Proxmox virtio-scsi defaults to sda
        laptop-install = mkInstaller "laptop" { device = "/dev/nvme0n1"; };
        desktop-install = mkInstaller "desktop" { device = "/dev/nvme0n1"; };
      };

      darwinConfigurations = {
        macbook = mkDarwin "macbook" "aarch64-darwin";       # Apple Silicon (M1+)
        macbook-intel = mkDarwin "macbook" "x86_64-darwin";  # Intel Macs
        # Same host config, different system arch. If you want
        # truly different per-arch hosts: make hosts/macbook-intel/.
      };

      nixOnDroidConfigurations = {
        phone = mkAndroid "phone";
      };
    };
}

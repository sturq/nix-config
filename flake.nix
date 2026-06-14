{
  description = "sturq's NixOS configs — laptop, desktop, wsl";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Declarative disk layouts (used by nixos-anywhere fresh installs).
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # System-wide theming via base16 + wallpaper sampling.
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Declarative Plasma 6 configuration.
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # Source of truth for the sturq palette (flake = false → we parse it
    # ourselves in lib/palette.nix).
    sturq-palette = {
      url = "github:sturq/sturq-palette";
      flake = false;
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, disko, stylix,
              plasma-manager, nixos-wsl,
              ... }@inputs:
    let
      palette = import ./lib/palette.nix { src = inputs.sturq-palette; };

      # gui = pull the Plasma layer on top of the CLI base.
      mkUser = { gui ? false }: {
        imports = [
          ./modules/home-manager/cli
        ] ++ nixpkgs.lib.optional gui ./modules/home-manager/desktop/plasma;
        home.username = "sturq";
        home.homeDirectory = "/home/sturq";
      };

      # Full NixOS host (Plasma 6 Wayland desktop).
      # hwConfig defaults to ./hosts/${hostName}/hardware-configuration.nix.
      # Pass null for installer variants where disko owns the partitioning.
      mkHost = hostName: {
        hwConfig ? ./hosts/${hostName}/hardware-configuration.nix,
        extraModules ? [],
      }: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs palette; };
        modules = [
          ./modules/nixos/system.nix
          ./modules/nixos/theme/stylix.nix
          ./hosts/${hostName}
          stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs palette; };
              sharedModules = [ plasma-manager.homeModules.plasma-manager ];
              users.sturq = mkUser { gui = true; };
              backupFileExtension = "hm-backup";
            };
          }
        ] ++ nixpkgs.lib.optional (hwConfig != null) hwConfig ++ extraModules;
      };

      # Installer variant (disko + nixos-anywhere). device is the target
      # disk path (override per fresh install): /dev/nvme0n1, /dev/vda…
      mkInstaller = hostName: { device ? "/dev/sda" }: mkHost hostName {
        hwConfig = null;
        extraModules = [
          ./modules/nixos/boot/disko.nix
          { disko.devices.disk.main.device = device; }
          disko.nixosModules.disko
        ];
      };

      # WSL host (NixOS-WSL, CLI only).
      mkWsl = hostName: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs palette; };
        modules = [
          ./hosts/${hostName}
          nixos-wsl.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs palette; };
              users.sturq = mkUser {};
              backupFileExtension = "hm-backup";
            };
          }
        ];
      };

      # Standalone home-manager (any distro).
      #   nix run home-manager -- switch --flake .#sturq
      mkHome = system: home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
        extraSpecialArgs = { inherit inputs palette; };
        modules = [ (mkUser {}) ];
      };
    in {
      nixosConfigurations = {
        laptop  = mkHost "laptop"  {};
        desktop = mkHost "desktop" {};
        wsl     = mkWsl  "wsl";

        laptop-install  = mkInstaller "laptop"  { device = "/dev/nvme0n1"; };
        desktop-install = mkInstaller "desktop" { device = "/dev/nvme0n1"; };
      };

      homeConfigurations = {
        sturq         = mkHome "x86_64-linux";
        sturq-aarch64 = mkHome "aarch64-linux";
      };
    };
}

{
  description = "sturq's NixOS configs — laptop, desktop, wsl (misterio77-style layout)";

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
      specialArgs = { inherit inputs palette; };

      # Full NixOS host (Plasma 6 Wayland desktop).
      mkHost = hostName: {
        hwConfig ? ./hosts/${hostName}/hardware-configuration.nix,
        extraModules ? [],
      }: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        inherit specialArgs;
        modules = [
          ./hosts/${hostName}
          stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = specialArgs;
              sharedModules = [ plasma-manager.homeModules.plasma-manager ];
              users.sturq = import ./home/sturq/${hostName}.nix;
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
          ./hosts/common/optional/disko.nix
          { disko.devices.disk.main.device = device; }
          disko.nixosModules.disko
        ];
      };

      # WSL host (NixOS-WSL, CLI only — skips hosts/common/global).
      mkWsl = hostName: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        inherit specialArgs;
        modules = [
          ./hosts/${hostName}
          nixos-wsl.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = specialArgs;
              users.sturq = import ./home/sturq/${hostName}.nix;
              backupFileExtension = "hm-backup";
            };
          }
        ];
      };

      # Standalone home-manager (any distro).
      #   nix run home-manager -- switch --flake .#sturq
      mkHome = system: home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
        extraSpecialArgs = specialArgs;
        modules = [ ./home/sturq/features/cli ];
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

{
  description = "sturq's NixOS configs — laptop, desktop, wsl (flat modules + HM layer)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

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

      # Home-manager modules picked per host. cli is always in; plasma
      # comes along for graphical hosts.
      homeModules = { gui }:
        [ ./home/sturq/cli ]
        ++ nixpkgs.lib.optional gui ./home/sturq/plasma;

      mkHost = hostName: {
        gui ? true,
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
              users.sturq.imports = homeModules { inherit gui; };
              backupFileExtension = "hm-backup";
            };
          }
        ] ++ nixpkgs.lib.optional (hwConfig != null) hwConfig ++ extraModules;
      };

      mkInstaller = hostName: { device ? "/dev/sda" }: mkHost hostName {
        hwConfig = null;
        extraModules = [
          ./modules/disko.nix
          { disko.devices.disk.main.device = device; }
          disko.nixosModules.disko
        ];
      };

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
              users.sturq.imports = homeModules { gui = false; };
              backupFileExtension = "hm-backup";
            };
          }
        ];
      };

      mkHome = system: home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
        extraSpecialArgs = specialArgs;
        modules = [ ./home/sturq/cli ];
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

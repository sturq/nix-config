{
  description = "sturq's machine configs — NixOS + macOS + WSL + standalone HM";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Declarative flatpak: services.flatpak.packages list deployed per
    # host. Used by HP250 for Sober (Roblox via Vinegar).
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

    # Single source of truth for the sturq palette. Plain data repo —
    # we treat it as raw source (flake = false) and parse
    # formats/palette.json ourselves in lib/palette.nix so the repo
    # stays language-agnostic.
    sturq-palette = {
      url = "github:sturq/sturq-palette";
      flake = false;
    };

    # Cross-platform: macOS + WSL.
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, nix-flatpak, disko, stylix,
              plasma-manager, nix-darwin, nixos-wsl,
              ... }@inputs:
    let
      # ---- Shared HM user definition --------------------------------------
      # gui = pulls the Plasma layer on top of the CLI base.
      # mac = use /Users/sturq instead of /home/sturq.
      mkUser = { gui ? false, mac ? false }: {
        imports = [
          ./modules/home-manager/cli
        ] ++ nixpkgs.lib.optional gui ./modules/home-manager/desktop/plasma;
        home.username = "sturq";
        home.homeDirectory = if mac then "/Users/sturq" else "/home/sturq";
      };

      # ---- Full NixOS host (Linux, KDE Plasma 6 Wayland desktop) ----------
      # hwConfig: defaults to ./hosts/${hostName}/hardware-configuration.nix.
      # Pass null for installer variants where disko owns the partitioning.
      mkHost = hostName: {
        hwConfig ? ./hosts/${hostName}/hardware-configuration.nix,
        extraModules ? [],
      }: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./modules/nixos/system.nix
          ./modules/nixos/theme/stylix.nix
          ./hosts/${hostName}
          nix-flatpak.nixosModules.nix-flatpak
          stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              sharedModules = [ plasma-manager.homeModules.plasma-manager ];
              users.sturq = mkUser { gui = true; };
              backupFileExtension = "hm-backup";
            };
          }
        ] ++ nixpkgs.lib.optional (hwConfig != null) hwConfig ++ extraModules;
      };

      # ---- Installer variant (Disko + nixos-anywhere) ---------------------
      # mkHost with disko swapped in for hardware-configuration. `device`
      # is the target disk path (override per host: nvme0n1, vda, mmcblk0…).
      # Deploy from any machine (even one running NixOS — kexec is used):
      #   nix run github:nix-community/nixos-anywhere -- --flake .#hp250-install root@<ip>
      mkInstaller = hostName: { device ? "/dev/sda" }: mkHost hostName {
        hwConfig = null;
        extraModules = [
          ./modules/nixos/boot/disko.nix
          { disko.devices.disk.main.device = device; }
          disko.nixosModules.disko
        ];
      };

      # ---- macOS host (nix-darwin) ----------------------------------------
      # Apple Silicon by default. For an Intel Mac, pass system explicitly.
      mkDarwin = hostName: { system ? "aarch64-darwin" }: nix-darwin.lib.darwinSystem {
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
              users.sturq = mkUser { mac = true; };
              backupFileExtension = "hm-backup";
            };
          }
        ];
      };

      # ---- WSL host (NixOS-WSL, no GUI, CLI only) -------------------------
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
              users.sturq = mkUser {};   # CLI only
              backupFileExtension = "hm-backup";
            };
          }
        ];
      };

      # ---- Standalone home-manager (any distro / bare macOS) --------------
      # On Fedora/Arch/Debian/anywhere with Nix:
      #   nix run home-manager -- switch --flake .#sturq
      # Standalone HM brings its own pkgs (allowUnfree because of claude-code).
      pkgsFor = system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      mkHome = system: userArgs: home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsFor system;
        extraSpecialArgs = { inherit inputs; };
        modules = [ (mkUser userArgs) ];
      };
    in {
      nixosConfigurations = {
        vivobook = mkHost "vivobook" {};
        hp250    = mkHost "hp250" {};
        wsl      = mkWsl  "wsl";

        # ---- Generic profiles (deploy to any laptop/desktop/mac) ----------
        laptop  = mkHost "laptop" {};
        desktop = mkHost "desktop" {};
        macbook = mkHost "macbook" {};   # NixOS on Intel Macs (pre-T2)

        # ---- Installer variants (nixos-anywhere + disko) ------------------
        vivobook-install = mkInstaller "vivobook" { device = "/dev/nvme0n1"; };
        laptop-install   = mkInstaller "laptop"   { device = "/dev/nvme0n1"; };
        desktop-install  = mkInstaller "desktop"  { device = "/dev/nvme0n1"; };
        macbook-install  = mkInstaller "macbook"  { device = "/dev/nvme0n1"; };
      };

      darwinConfigurations = {
        # Apple Silicon. For Intel:  mkDarwin "macos" { system = "x86_64-darwin"; }
        macbook = mkDarwin "macos" {};
      };

      homeConfigurations = {
        sturq         = mkHome "x86_64-linux"   {};
        sturq-aarch64 = mkHome "aarch64-linux"  {};
        sturq-mac     = mkHome "aarch64-darwin" { mac = true; };
      };
    };
}

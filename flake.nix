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

    # Cross-platform: macOS + WSL
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
      # ---- Full NixOS host (Linux, KDE Plasma 6 Wayland desktop) ----
      # hwConfig: defaults to ./hosts/${hostName}/hardware-configuration.nix.
      # Pass null for installer variants where disko owns the partitioning.
      mkHost = hostName: {
        hwConfig ? ./hosts/${hostName}/hardware-configuration.nix,
        extraModules ? [],
      }: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/common/global
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
              users.sturq = import ./home/sturq/nixos.nix;
              backupFileExtension = "hm-backup";
            };
          }
        ] ++ nixpkgs.lib.optional (hwConfig != null) hwConfig ++ extraModules;
      };

      # ---- Installer variant (Disko + nixos-anywhere) ----
      # mkHost with disko swapped in for hardware-configuration. `device`
      # is the target disk path (overrides: nvme0n1, vda, mmcblk0…).
      # Deploy from any machine (even one running NixOS — kexec is used):
      #   nix run github:nix-community/nixos-anywhere -- --flake .#hp250-install root@<ip>
      mkInstaller = hostName: { device ? "/dev/sda" }: mkHost hostName {
        hwConfig = null;
        extraModules = [
          ./hosts/common/optional/boot/disko.nix
          { disko.devices.disk.main.device = device; }
          disko.nixosModules.disko
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
    in {
      nixosConfigurations = {
        vivobook = mkHost "vivobook" {};
        hp250 = mkHost "hp250" {};
        wsl = mkWsl "wsl";

        # ---- Generic profiles (deploy to any laptop/desktop on the fly) ----
        laptop = mkHost "laptop" {};
        desktop = mkHost "desktop" {};

        # ---- Installer variants (for nixos-anywhere + disko) ----
        vivobook-install = mkInstaller "vivobook" { device = "/dev/nvme0n1"; };
        laptop-install = mkInstaller "laptop" { device = "/dev/nvme0n1"; };
        desktop-install = mkInstaller "desktop" { device = "/dev/nvme0n1"; };
      };

      darwinConfigurations = {
        macbook = mkDarwin "macbook" "aarch64-darwin";       # Apple Silicon (M1+)
        macbook-intel = mkDarwin "macbook" "x86_64-darwin";  # Intel Macs
        # Same host config, different system arch. If you want
        # truly different per-arch hosts: make hosts/macbook-intel/.
      };

      # ---- Standalone home-manager (for non-NixOS distros) ----
      # On Fedora/Arch/Debian/whatever: install Nix (Determinate installer),
      # then:
      #   nix run home-manager/master -- switch --flake .#sturq
      # You get the full home/sturq/common/global CLI layer on any distro.
      homeConfigurations =
        let
          # Standalone HM doesn't inherit NixOS-side nixpkgs.config —
          # has to bring its own allowUnfree (claude-code is unfree).
          pkgsFor = system: import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          mkHome = system: entrypoint: home-manager.lib.homeManagerConfiguration {
            pkgs = pkgsFor system;
            extraSpecialArgs = { inherit inputs; };
            modules = [ entrypoint ];
          };
        in {
          # Linux: CLI only — shell, git, tools. Same layer that WSL gets.
          sturq          = mkHome "x86_64-linux"   ./home/sturq/cli.nix;
          sturq-aarch64  = mkHome "aarch64-linux"  ./home/sturq/cli.nix;

          # macOS standalone (if you're not using nix-darwin for system).
          sturq-mac       = mkHome "aarch64-darwin" ./home/sturq/darwin.nix;
          sturq-mac-intel = mkHome "x86_64-darwin"  ./home/sturq/darwin.nix;
        };
    };
}

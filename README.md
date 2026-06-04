<div align="center">

# nix-config

sturq's multi-platform Nix flake — NixOS, nix-darwin, nix-on-droid, NixOS-WSL.
One repo, one `flake.lock`, every machine reproducible from `git pull`.

![hp250 — Sway + Waybar + Stylix](./screenshots/desktop.png)

</div>

---

## Stack

- **KDE Plasma 6 (Wayland)** + **SDDM** greeter
- **Stylix** with the [sturq-palette](https://github.com/sturq/sturq-palette)
  OLED scheme — base16-based theming for Qt/KDE/foot/firefox/etc.
- **adw-gtk3-dark** for every GTK app — libadwaita-style dark across the GTK side
- **GRUB + os-prober** — automatic Windows dual-boot detection
- **Disko + nixos-anywhere** for declarative fresh installs from any other
  Linux box (kexec-bootstrap works on existing NixOS too)
- **TLP auto-switching** on hp250 — full `performance` governor + CPU boost
  on AC, `powersave` + ASPM `powersupersave` + WiFi pwr-mgmt on battery.
  Plus kernel-level: i915 PSR/FBC, deep S3 sleep, thermald
- **Tailscale** baked in — `sudo tailscale up` and the host joins the tailnet
- **Steam + Sober (Flatpak Roblox)** declared in `hosts/hp250/default.nix`

---

## Hosts

| Output | Use |
|---|---|
| `nixosConfigurations.hp250` | HP 250 G9 (Intel i5-1235U) — active dev laptop |
| `nixosConfigurations.vivobook` | ASUS Vivobook S 14 M5406WA (AMD Strix Point) |
| `nixosConfigurations.vm` | Proxmox test VM (auto-login) |
| `nixosConfigurations.wsl` | NixOS-WSL inside Windows |
| `nixosConfigurations.hp250-install` | Disko + nixos-anywhere variant for hp250 |
| `nixosConfigurations.vivobook-install` | Disko + nixos-anywhere variant for vivobook |
| `nixosConfigurations.vm-install` | Disko + nixos-anywhere variant for vm |
| `darwinConfigurations.macbook` | Apple Silicon (aarch64-darwin) |
| `darwinConfigurations.macbook-intel` | Intel Macs (x86_64-darwin) |
| `nixOnDroidConfigurations.phone` | Android (Termux + nix-on-droid) |

---

## Fresh install (Disko + nixos-anywhere)

Works on any Linux target (including a running NixOS — kexec is used).

```sh
nix run github:nix-community/nixos-anywhere -- \
  --flake .#hp250-install \
  root@<target-ip>
```

Disko applies the layout from `modules/disko.nix`:
1 G ESP + BTRFS root with subvolumes `@root @home @nix @snap @swap` +
zstd compression + 16 G swapfile. No LUKS.

Disk path defaults to `/dev/sda`; the per-host installer outputs in
`flake.nix` set it to the right device (`/dev/nvme0n1` for hp250 +
vivobook, `/dev/vda` for vm).

---

## Daily use

```sh
cd /etc/nixos
$EDITOR hosts/hp250/default.nix
sudo nixos-rebuild switch --flake .#hp250
git add -A && git commit -m "..." && git push

# Update inputs
nix flake update
sudo nixos-rebuild switch --flake .#hp250

# Rollback
sudo nixos-rebuild --rollback switch
# (or pick an older generation in the systemd-boot menu)
```

---

## Layout

```
flake.nix                      Composition root. Inputs + mkHost/mkInstaller/...

hosts/
  hp250/                       HP 250 G9 (active dev)
  vivobook/                    ASUS Vivobook (placeholder hardware-config)
  vm/                          Proxmox test VM
  wsl/                         NixOS-WSL
  macbook/                     nix-darwin
  phone/                       nix-on-droid

modules/                       System-level reusable modules.
  base.nix                     Boot, network, locale, user, nix settings.
  desktop/
    default.nix                Plasma 6 + SDDM + pipewire + xdg-portal-kde +
                               system fonts. KWin handles tiling natively.
    autologin.nix              Optional: SDDM autologin straight into Plasma.
  intel-laptop.nix             Intel laptop tuning (PSR, ASPM, deep sleep, …).
  amd-laptop.nix               AMD Zen 5 tuning (asusd, amd_pstate, charge limit).
  tailscale.nix                Tailscale service.
  stylix.nix                   sturq-palette via Stylix (Bibata cursor + fonts).
  disko.nix                    Generic BTRFS layout for mkInstaller.

home/
  sturq/                       Per-platform entry points.
    nixos.nix                  Linux: imports cli + desktop features.
    cli.nix                    CLI-only: just cli features (WSL/servers).
    darwin.nix                 macOS: cli + Mac bits.
  features/
    cli/                       Shared CLI — shell, git, ssh, direnv, tools,
                               nix-cli, claude-code. Used on every platform.
    desktop/
      default.nix              GUI apps (firefox, keepassxc, yazi, helix, mpv,
                               zathura, imv) + adw-gtk3-dark GTK theme.
```

---

## Keybinds

Plasma 6 defaults already match GlazeWM closely (Win+arrows to snap, Win+L
lock, Win+E Dolphin, Win+1..4 virtual desktops). The cross-platform mirror
with identical bindings lives at [`sturq/win-glazewm`](https://github.com/sturq/win-glazewm).

---

## What's not in the repo

- Passwords (set via `users.users.sturq.initialPassword` on first boot;
  user changes them with `passwd` afterward)
- SSH private keys, API tokens, WiFi credentials
- `hosts/hp250/hardware-configuration.nix` is committed; other hosts hold
  placeholders that get regenerated by `nixos-anywhere --generate-hardware-config`
  during fresh install

---

## Mirrors

- Windows tiling equivalent: [`sturq/win-glazewm`](https://github.com/sturq/win-glazewm)
  (GlazeWM + Zebar, same keybinds, same palette)
- Palette source: [`sturq/sturq-palette`](https://github.com/sturq/sturq-palette)

---

## Credits

- [home-manager](https://github.com/nix-community/home-manager)
- [Stylix](https://github.com/danth/stylix)
- [disko](https://github.com/nix-community/disko)
- [nixos-anywhere](https://github.com/nix-community/nixos-anywhere)
- [nix-on-droid](https://github.com/nix-community/nix-on-droid)
- [nix-darwin](https://github.com/nix-darwin/nix-darwin)
- [NixOS-WSL](https://github.com/nix-community/NixOS-WSL)
- [nix-flatpak](https://github.com/gmodena/nix-flatpak)
- [Sway](https://github.com/swaywm/sway), [Waybar](https://github.com/Alexays/Waybar), [ReGreet](https://github.com/rharish101/ReGreet)
- Structural inspiration: [Misterio77/nix-config](https://github.com/Misterio77/nix-config)

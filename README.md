<div align="center">

# nix-config

sturq's multi-platform Nix flake — NixOS, nix-darwin, nix-on-droid, NixOS-WSL.
One repo, one `flake.lock`, every machine reproducible from `git pull`.

![hp250 — Plasma 6 + KWin + Stylix](./screenshots/desktop.png)

</div>

---

## Stack

- **KDE Plasma 6 (Wayland)** + **SDDM** greeter
- **Stylix** with the [sturq-palette](https://github.com/sturq/sturq-palette)
  OLED scheme — base16-based theming for Qt/KDE/foot/firefox/etc.
- **plasma-manager** — declarative panel layout, hotkeys, kdeglobals, lock, power
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
| `nixosConfigurations.laptop` | Generic laptop — deploy to any Intel/AMD laptop |
| `nixosConfigurations.desktop` | Generic desktop tower |
| `nixosConfigurations.wsl` | NixOS-WSL inside Windows |
| `nixosConfigurations.hp250-install` | Disko + nixos-anywhere variant for hp250 |
| `nixosConfigurations.vivobook-install` | Disko + nixos-anywhere variant for vivobook |
| `nixosConfigurations.vm-install` | Disko + nixos-anywhere variant for vm |
| `nixosConfigurations.laptop-install` | Disko + nixos-anywhere variant — any laptop |
| `nixosConfigurations.desktop-install` | Disko + nixos-anywhere variant — any desktop |
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

Disko applies the layout from `hosts/common/optional/disko.nix`:
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

## Colours

Every colour comes from [sturq-palette](https://github.com/sturq/sturq-palette),
pulled as `flake = false` and parsed in [`lib/palette.nix`](./lib/palette.nix).
The palette repo only ships tokens — this repo decides which token paints which
surface:

| Surface | Token |
|---|---|
| desktop wallpaper | `surfaces.surface0` (midnight navy) |
| terminal background (via Stylix base00) | `surfaces.crust` (OLED black) |
| Plasma accent / selection | `core.primary` (lavender) |
| lockscreen | `surfaces.crust` (OLED black) |
| ANSI accents (red/green/blue/…) | `accents.*` (Termux defaults) |

The role mapping lives in [`lib/palette.nix`](./lib/palette.nix) as a single
`roles` attrset — every consumer (Stylix, plasma-manager theme, Konsole, GRUB)
reads from the same source. Want a different colour for the wallpaper? Change
one line in `lib/palette.nix`.

---

## Layout

Misterio77-style split: `hosts/common/global/` is auto-imported by every
NixOS host (no `enable` flag, just file imports), `hosts/common/optional/`
is opted into per host.

```
flake.nix                     Composition root. Inputs + mkHost/mkInstaller/...
lib/palette.nix               Parser for sturq-palette → base16 + semantic
                              roles (accent / wallpaper / lockscreen) used
                              everywhere downstream.

hosts/
  common/
    global/                   Auto-imported by every NixOS host.
      default.nix             Boot loader, network, locale, user, nix.
      stylix.nix              Palette → Stylix (kdeglobals colours, cursor,
                              GTK theme, console ANSI, fonts).
    optional/                 Per-host opt-in via plain imports.
      plasma6.nix             Plasma 6 + SDDM + pipewire + portal-kde.
      autologin.nix           Skip the SDDM greeter.
      steam.nix               programs.steam + firewall.
      flatpak.nix             services.flatpak (hosts add their own packages).
      tailscale.nix           Tailscale + DNS reverse-path tweak.
      dualboot-grub.nix       GRUB + os-prober + palette-themed boot menu +
                              memtest / UEFI / reboot / power-off entries.
      dev-defaults.nix        OpenSSH + initial passwords for dev boxes.
      disko.nix               Generic BTRFS layout used by mkInstaller.
      hardware/
        laptop.nix            TLP, lid, brightness.
        desktop.nix           perf governor, no idle.

  hp250/                      HP 250 G9 — Intel laptop, Windows dual-boot.
  vivobook/                   ASUS Vivobook S 14 — AMD Strix Point.
  vm/                         Proxmox test VM.
  laptop/  desktop/           Generic hosts for fresh nixos-anywhere installs.
  wsl/                        NixOS-WSL.
  macbook/                    nix-darwin.
  phone/                      nix-on-droid.

modules/home/                 home-manager (user level).
  cli/                        shell, git, ssh, direnv, tools, nix.
  plasma6/                    theme, panel, shortcuts, session, konsole.

home/sturq/                   home-manager entry points per platform.
  nixos.nix                   Linux: imports cli + plasma6.
  cli.nix                     CLI-only (WSL, headless).
  darwin.nix                  macOS: cli only.
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
- [plasma-manager](https://github.com/nix-community/plasma-manager) — declarative Plasma 6 config
- Structural inspiration: [Misterio77/nix-config](https://github.com/Misterio77/nix-config)

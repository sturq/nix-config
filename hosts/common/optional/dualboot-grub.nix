{ pkgs, inputs, ... }:

let
  palette = import ../../../lib/palette.nix { src = inputs.sturq-palette; };

  # OLED pure black regardless of palette, same rule as the lockscreen.
  # Accent + text still follow the palette so the boot screen reads as
  # "this user's palette on a black canvas".
  bg     = palette.roles.lockscreen;
  accent = palette.roles.accent;
  fg     = "#${palette.base16Scheme.base05}";
  dim    = "#${palette.base16Scheme.base03}";

  # GRUB renders pre-X, so the theme is a few PNGs + a layout file.
  # Generate font sizes alongside the PNGs — referencing a font name
  # (e.g. "DejaVu Sans Bold 20") only works if a .pf2 with that exact
  # name + size is loaded; without it GRUB falls back to text mode and
  # the whole theme silently skips.
  grubTheme = pkgs.runCommand "grub-theme-palette" {
    buildInputs = [ pkgs.imagemagick pkgs.grub2 pkgs.dejavu_fonts ];
  } ''
    mkdir -p $out

    magick -size 1920x1080 xc:'${bg}' $out/background.png
    magick -size 16x40    xc:'${accent}' $out/select_c.png
    magick -size 4x40     xc:'${accent}' $out/select_w.png
    magick -size 4x40     xc:'${accent}' $out/select_e.png

    # Convert TTF → .pf2 at every size theme.txt references. -n is the
    # font name GRUB looks up; must match the theme.txt strings exactly.
    DEJAVU=${pkgs.dejavu_fonts}/share/fonts/truetype
    grub-mkfont -s 20 -n "DejaVu Sans Bold 20"    -o $out/dejavu-bold-20.pf2    $DEJAVU/DejaVuSans-Bold.ttf
    grub-mkfont -s 14 -n "DejaVu Sans Regular 14" -o $out/dejavu-regular-14.pf2 $DEJAVU/DejaVuSans.ttf
    grub-mkfont -s 11 -n "DejaVu Sans Regular 11" -o $out/dejavu-regular-11.pf2 $DEJAVU/DejaVuSans.ttf

    cat > $out/theme.txt <<EOF
    title-text: ""
    desktop-image: "background.png"
    desktop-color: "${bg}"
    message-color: "${fg}"
    message-bg-color: "${bg}"

    + label {
      left = 50%-120
      top  = 10%
      width = 240
      height = 32
      align = "center"
      color = "${fg}"
      font = "DejaVu Sans Bold 20"
      text = "NixOS"
    }

    + boot_menu {
      left = 25%
      top  = 22%
      width = 50%
      height = 56%
      item_height = 42
      item_padding = 12
      item_icon_space = 12
      item_spacing = 4
      item_font = "DejaVu Sans Regular 14"
      item_color = "${fg}"
      selected_item_color = "${bg}"
      selected_item_pixmap_style = "select_*.png"
      menu_pixmap_style = ""
    }

    + progress_bar {
      id = "__timeout__"
      left = 25%
      top  = 82%
      width = 50%
      height = 20
      show_text = true
      text = "@TIMEOUT_NOTIFICATION_LONG@"
      font = "DejaVu Sans Regular 11"
      border_color = "${dim}"
      bg_color = "${bg}"
      fg_color = "${accent}"
      text_color = "${fg}"
    }
    EOF
  '';
in {
  boot.loader.systemd-boot.enable = false;

  boot.loader.grub = {
    enable = true;
    device = "nodev";          # EFI install
    efiSupport = true;
    useOSProber = true;
    configurationLimit = 10;
    default = 0;               # newest gen; `saved` drifts during rollbacks
    timeoutStyle = "menu";

    theme = grubTheme;
    splashImage = "${grubTheme}/background.png";

    # The auto mode sometimes fails on Intel GOP (HP 250 G9) and GRUB
    # drops to text mode (the bright-blue console default). Pin a known
    # native resolution so gfxterm always succeeds.
    gfxmodeEfi = "1920x1080";
    gfxpayloadEfi = "keep";

    memtest86.enable = true;

    # Power/firmware shortcuts so the user doesn't have to spam F-keys to
    # reach UEFI setup. fwsetup / reboot / halt are GRUB built-ins, so no
    # extra binaries are trusted.
    extraEntries = ''
      menuentry "Reboot to UEFI Firmware Settings" --class restart {
        fwsetup
      }
      menuentry "Reboot" --class reboot {
        reboot
      }
      menuentry "Power Off" --class shutdown {
        halt
      }
    '';
  };

  boot.loader.timeout = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  # We own GRUB theming via the palette; disable Stylix's grub target so
  # only one set of files lands in /boot/theme.
  stylix.targets.grub.enable = false;
}

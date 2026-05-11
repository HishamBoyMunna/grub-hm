# Multi-OS Selector GRUB Theme

A fun, interactive GRUB theme that simulates OS selection with visual feedback. Choose between Arch Linux (DedSec theme) or a hilarious Blue Screen of Death (Windows joke).

## Features

- **Matrix Main Menu**: Epic sci-fi boot screen (Red Pill/Blue Pill reference)
- **Arch Linux Submenu**: DedSec-themed hacker aesthetic with all Arch boot options
- **Windows Joke**: Permanent Blue Screen of Death (BSOD) until you press ESC
- **Easy Navigation**: ESC returns you to the main menu from any submenu
- **1920x1080 Resolution**: Full HD support for modern displays

## Boot Flow

```
┌─────────────────────────┐
│  GRUB Loads             │
│  Matrix Theme Applied   │
├─────────────────────────┤
│  Main Menu:             │
│  • Arch Linux           │
│  • Windows              │
│  • UEFI Firmware        │
└─────────────────────────┘
        │
        ├─→ User selects "Arch Linux"
        │       ↓
        │   ┌──────────────────────┐
        │   │ DedSec Submenu       │
        │   │ (Arch boot entries)  │
        │   └──────────────────────┘
        │
        └─→ User selects "Windows"
                ↓
            ┌──────────────────────┐
            │ BSOD Full Screen     │
            │ (Stuck until ESC)    │
            └──────────────────────┘
```

## Installation

### Prerequisites

- Arch Linux system
- GRUB 2.04+ (2.14 recommended)
- Root/sudo access
- Existing boot entries: Arch Linux, Advanced options for Arch Linux, UEFI Firmware, Arch Linux snapshots

### Steps

1. **Clone or extract the theme files** to your workspace:
   ```bash
   cd /path/to/multi-os-selector
   ```

2. **Run the installer** with sudo:
   ```bash
   sudo bash install-multi-theme.sh
   ```

   The installer will:
   - Validate your system
   - Create `/boot/grub/themes/multi-os-selector/`
   - Copy theme files, fonts, and images
   - Backup your `/etc/default/grub`
   - Update GRUB configuration
   - Regenerate GRUB menu
   - Ask if you want to reboot

3. **Reboot** to see the new theme:
   ```bash
   sudo reboot
   ```

## File Structure

```
multi-os-selector/
├── theme-matrix-main.txt          # Primary Matrix theme (main menu)
├── theme-dedsec.txt               # DedSec theme (Arch submenu)
├── theme-windows-bsod.txt         # BSOD theme (Windows joke submenu)
├── grub-custom-menu.cfg           # Custom menu structure
├── 40_custom_multi_os             # GRUB.d script (optional)
├── install-multi-theme.sh         # Installation script
└── README.md                       # This file
```

## What Gets Installed

After running the installer, GRUB will have this structure:

```
/boot/grub/themes/multi-os-selector/
├── theme-matrix-main.txt          # Main menu theme
├── theme-dedsec.txt               # Arch submenu theme
├── theme-windows-bsod.txt         # BSOD joke theme
├── font.pf2                        # Matrix font
├── fonts/
│   ├── hackb_18.pf2              # DedSec font (Hack)
│   ├── norwester_16.pf2          # DedSec font
│   ├── norwester_20.pf2          # DedSec font
│   └── norwester_22.pf2          # DedSec font
├── matrix-background.png          # Matrix main menu image
├── dedsec-background.png          # DedSec submenu background
├── bluescreen.png                 # BSOD image (1920x1080)
└── assets/
    └── icons/                     # DedSec icons (optional)
```

## Configuration Files Modified

- `/etc/default/grub` — Updated GRUB_THEME setting, backed up as `grub.backup`
- `/boot/grub/grub.cfg` — Regenerated with new menu structure

## Usage

### Normal Boot
1. Power on computer
2. GRUB menu appears with Matrix theme
3. Use arrow keys (↑/↓) to navigate: "Arch Linux" or "Windows"
4. Press Enter to select

### Arch Linux Path
- Select "Arch Linux" → Submenu with DedSec theme appears
- Shows: Arch Linux, Advanced options for Arch Linux, Arch Linux snapshots
- Select your kernel variant → Boot Arch Linux
- Use ↑/↓ to navigate, Enter to boot, ESC to return to main menu

### Windows BSOD Path (The Joke)
- Select "Windows" → **BLUE SCREEN OF DEATH APPEARS**
- Computer appears to have crashed with BSOD
- **Press ESC to "escape the crash"** and return to main menu
- BSOD stays on screen until ESC is pressed (permanent joke)

## Troubleshooting

### Theme Not Applied
- Verify GRUB version: `grub-mkconfig --version`
- Should be GRUB 2.04 or later
- Check GRUB_THEME in `/etc/default/grub`:
  ```bash
  cat /etc/default/grub | grep GRUB_THEME
  ```

### Fonts Not Found
- Check fonts directory exists: `ls /boot/grub/themes/multi-os-selector/fonts/`
- If missing, re-run installer

### BSOD Not Displaying
- Verify bluescreen.png exists: `ls /boot/grub/themes/multi-os-selector/bluescreen.png`
- Check if image is 1920x1080: `file /boot/grub/themes/multi-os-selector/bluescreen.png`

### GRUB Regeneration Failed
- Installer backs up `/etc/default/grub` automatically
- Restore with: `sudo cp /etc/default/grub.backup /etc/default/grub`
- Then manually run: `sudo grub-mkconfig -o /boot/grub/grub.cfg`

### Reverting to Original GRUB
```bash
# Restore backed up grub config
sudo cp /etc/default/grub.backup /etc/default/grub

# Regenerate GRUB
sudo grub-mkconfig -o /boot/grub/grub.cfg

# Remove theme directory (optional)
sudo rm -rf /boot/grub/themes/multi-os-selector
```

## Customization

### Change Main Menu Background
Replace `matrix-background.png` in `/boot/grub/themes/multi-os-selector/`

### Change Arch Submenu Background
Replace `dedsec-background.png`

### Change BSOD Image
Replace `bluescreen.png` (must be 1920x1080 PNG)

### Modify Colors
Edit the theme files (`.txt`):
- `theme-matrix-main.txt` — Main menu colors
- `theme-dedsec.txt` — Arch submenu colors
- `theme-windows-bsod.txt` — BSOD theme colors

Then regenerate GRUB: `sudo grub-mkconfig -o /boot/grub/grub.cfg`

## System Requirements

- **GRUB Version**: 2.04+ (tested on 2.14)
- **Display Resolution**: 1920x1080 (Full HD)
- **Linux Distro**: Arch Linux (verified on current)
- **Boot Mode**: EFI (UEFI) or BIOS (both supported)
- **Disk Space**: ~50 MB for theme files

## Credits

- **Matrix Theme** based on: Matrix Morpheus GRUB Theme
- **DedSec Theme** based on: DedSec GRUB2 Theme
- **BSOD Image**: Custom Windows crash screen (1920x1080)
- **Installation Script**: Custom Bash automation for Arch Linux

## License

Free to use and modify. Share and enjoy! 🎬

## Notes

- GRUB submenus don't fully reload themes in standard implementation
- Visual differentiation achieved through menu structure and styling
- Windows entry is purely decorative (no actual Windows system needed)
- ESC behavior is native GRUB functionality (no custom code)
- Theme files use GRUB configuration syntax (not CSS or other formats)

## Support

If you encounter issues:
1. Check all files are in place: `ls -la /boot/grub/themes/multi-os-selector/`
2. Verify GRUB config: `cat /etc/default/grub | grep GRUB_THEME`
3. Check GRUB version: `grub-mkconfig --version`
4. Review system logs: `sudo journalctl -b` (recent boot messages)

---

**Enjoy your Matrix-themed GRUB boot menu! May you always choose the right pill.** 🔴🔵

# QUICK START - Multi-OS Selector GRUB Theme

## What You Have

Complete GRUB theme package ready for installation on your Arch Linux system:

```
multi-os-selector/
├── theme-matrix-main.txt          ← Matrix main menu theme
├── theme-dedsec.txt               ← Arch submenu (DedSec) theme
├── theme-windows-bsod.txt         ← Windows BSOD joke theme
├── install-multi-theme.sh         ← Main installation script ⭐
├── reorganize-entries.sh          ← Entry reorganization helper
├── revert-grub.sh                 ← Revert helper (restore original GRUB)
├── 40_custom_multi_os             ← GRUB script (reference)
├── grub-custom-menu.cfg           ← Custom menu config (reference)
└── README.md                       ← Full documentation
```

## Installation (3 Steps)

### Step 1: Copy Files to Your System
```bash
# Navigate to the directory where install-multi-theme.sh is located
cd /path/to/multi-os-selector

# Make the installer executable
chmod +x install-multi-theme.sh reorganize-entries.sh revert-grub.sh
```

### Step 2: Run Installation (Requires Sudo)
```bash
sudo bash install-multi-theme.sh
```

This will:
- ✓ Validate your GRUB installation
- ✓ Create `/boot/grub/themes/multi-os-selector/`
- ✓ Copy all theme files, fonts, and images
- ✓ Update `/etc/default/grub` to use the new theme
- ✓ Backup your original GRUB config
- ✓ Regenerate GRUB configuration
- ✓ Ask if you want to reboot

### Step 3: Reorganize Boot Entries (Optional but Recommended)
```bash
sudo bash reorganize-entries.sh
```

This will:
- ✓ Move Arch entries into a submenu (DedSec theme)
- ✓ Create Windows submenu (BSOD joke)
- ✓ Keep UEFI Firmware Settings in main menu
- ✓ Regenerate GRUB
- ✓ Ask if you want to reboot

**Or just reboot directly:**
```bash
sudo reboot
```

## Boot Menu Structure (After Installation)

When you boot, you'll see:

```
┌─────────────────────────────────────┐
│  MATRIX GRUB THEME - Main Menu      │
│                                     │
│  Arch Linux                         │
│  Windows                            │
│  UEFI Firmware Settings             │
│                                     │
│  Navigate: ↑↓  Select: Enter  Exit: Esc
└─────────────────────────────────────┘
```

### Scenario 1: Boot Arch Linux
1. Select "Arch Linux" from main menu
2. Press Enter
3. **DedSec theme** loads (hacker aesthetic)
4. See submenu:
   - Arch Linux
   - Advanced options for Arch Linux
   - Arch Linux snapshots
5. Select your kernel → Boot

### Scenario 2: Select Windows (The Joke)
1. Select "Windows" from main menu
2. Press Enter
3. **BLUE SCREEN OF DEATH** appears (1920x1080 full screen)
4. Computer appears to have crashed
5. **Press ESC** to "escape the crash" and return to Matrix menu
6. Repeat joke or select Arch Linux to actually boot

### Scenario 3: Return to Main Menu
- Press **ESC** from any submenu → Returns to Matrix main menu
- Useful if you change your mind about which OS to boot

## File Contents Summary

### Theme Files (`.txt` files)

**theme-matrix-main.txt**
- Green text on black background (Matrix style)
- Full-screen menu layout
- Main OS selection screen

**theme-dedsec.txt**
- Hacker-themed with DedSec styling
- Centered menu box (20% left, 30% top, 60% width)
- Shows Arch boot options with icons and scrollbar

**theme-windows-bsod.txt**
- Full-screen bluescreen.png background
- Hidden menu elements (user can't interact)
- Permanent display until ESC is pressed

### Script Files (`.sh` files)

**install-multi-theme.sh**
- Main installer: validates system, copies files, updates GRUB
- Creates `/boot/grub/themes/multi-os-selector/` directory
- Backs up original `/etc/default/grub`
- Regenerates GRUB configuration

**reorganize-entries.sh**
- Optional helper: reorganizes boot entries into submenus
- Wraps Arch entries into DedSec-themed submenu
- Adds Windows joke submenu
- Can be run after initial install or combined with main installer

**revert-grub.sh**
- Revert helper: restores `/etc/default/grub` from the install backup
- Regenerates GRUB config and optionally removes the installed theme directory
- Use this to safely roll back the installer changes

## What Gets Installed

### On Your System
```
/boot/grub/themes/multi-os-selector/
├── theme-matrix-main.txt          ← Matrix theme config
├── theme-dedsec.txt               ← DedSec theme config
├── theme-windows-bsod.txt         ← BSOD theme config
├── font.pf2                        ← Matrix font
├── bluescreen.png                 ← Windows BSOD image (1920x1080)
├── matrix-background.png          ← Matrix menu background
├── dedsec-background.png          ← DedSec submenu background
├── fonts/
│   ├── hackb_18.pf2              ← DedSec font (Hack)
│   ├── norwester_16.pf2          ← DedSec font
│   ├── norwester_20.pf2          ← DedSec font
│   └── norwester_22.pf2          ← DedSec font
└── assets/icons/                  ← DedSec icons (optional)
```

### Configuration Changes
- `/etc/default/grub` — Updated with new GRUB_THEME path
- `/boot/grub/grub.cfg` — Regenerated with new menu structure
- Backup of original: `/etc/default/grub.backup`

## System Requirements

- **OS**: Arch Linux
- **GRUB**: Version 2.04+ (your system has 2.14 ✓)
- **Display**: 1920x1080 (Full HD)
- **Permissions**: Root/sudo access

## Troubleshooting

### Theme not showing?
```bash
# Verify GRUB theme was set
cat /etc/default/grub | grep GRUB_THEME
# Should show: GRUB_THEME="/boot/grub/themes/multi-os-selector/theme-matrix-main.txt"

# Check files are in place
ls /boot/grub/themes/multi-os-selector/
```

### BSOD not displaying?
```bash
# Verify bluescreen.png exists and is correct size
file /boot/grub/themes/multi-os-selector/bluescreen.png
# Should be: PNG image data, 1920 x 1080
```

### Fonts missing?
```bash
# Check fonts directory
ls /boot/grub/themes/multi-os-selector/fonts/
# Should contain: hackb_18.pf2, norwester_16.pf2, norwester_20.pf2, norwester_22.pf2
```

### Want to revert?
Use the provided revert helper to restore your original GRUB configuration and optionally remove the installed theme directory:

```bash
sudo bash /path/to/multi-os-selector/revert-grub.sh
```

If you prefer to revert manually, the operations performed by the helper are equivalent to:

```bash
sudo cp /etc/default/grub.backup /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo rm -rf /boot/grub/themes/multi-os-selector   # optional
```

## Customization

### Change the Windows BSOD Image
Replace `bluescreen.png` (must be 1920x1080 PNG):
```bash
sudo cp /path/to/your/image.png /boot/grub/themes/multi-os-selector/bluescreen.png
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### Change Colors
Edit theme files (e.g., `theme-matrix-main.txt`) to modify colors:
```bash
sudo nano /boot/grub/themes/multi-os-selector/theme-matrix-main.txt
# Change: item_color = "#00AA00" (green)
# To your preferred hex color
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### Change Fonts
Edit theme files to specify different fonts:
```bash
# In theme-dedsec.txt, change:
# item_font = "Norwester Regular 20"
# To your preferred .pf2 font name
```

## Next Steps

1. **Copy the multi-os-selector folder** to your system
2. **Run `sudo bash install-multi-theme.sh`** to install theme and files
3. **(Optional) Run `sudo bash reorganize-entries.sh`** to organize boot entries
4. **Reboot** to see the new GRUB menu
5. **Enjoy!** Select Arch to boot normally, Windows for a laugh

## Pro Tips

- **Keep the installer scripts** in case you need to reinstall or troubleshoot
- **Backup `/etc/default/grub`** before making manual changes
- **Test in virtual machine first** if you want to preview before real system boot
- **Read README.md** for complete documentation and detailed configuration

---

**Questions? See README.md for complete documentation.**

May the Matrix load properly! 🎬

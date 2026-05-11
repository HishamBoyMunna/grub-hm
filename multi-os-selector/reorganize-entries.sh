#!/bin/bash
# =============================
# GRUB Entry Reorganizer
# Moves Arch boot entries into submenu
# =============================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

GRUB_D_DIR="/etc/grub.d"
CUSTOM_SCRIPT="$GRUB_D_DIR/40_custom_multi_os"
CUSTOM_MAIN="$GRUB_D_DIR/40_custom"

echo -e "${GREEN}=== GRUB Entry Reorganizer ===${NC}"
echo ""

if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}This script must be run as root!${NC}"
   exit 1
fi

echo -e "${YELLOW}This script will reorganize your GRUB entries into submenus.${NC}"
echo -e "${YELLOW}Backup of /etc/grub.d/40_custom will be created.${NC}"
echo ""

# Read current entries
echo -e "${YELLOW}Detected boot entries:${NC}"
if [[ -f "$CUSTOM_MAIN" ]]; then
    # Extract menuentry lines
    grep "^menuentry\|^submenu" "$CUSTOM_MAIN" | head -20 | while read line; do
        echo "  $line"
    done
fi

echo ""
echo -e "${YELLOW}The installer will now create submenus for:${NC}"
echo "  • Arch Linux submenu (DedSec theme)"
echo "    ├─ Arch Linux"
echo "    ├─ Advanced options for Arch Linux"
echo "    └─ Arch Linux snapshots"
echo "  • Windows submenu (BSOD joke)"
echo ""

read -p "Continue with entry reorganization? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 0
fi

echo -e "${YELLOW}Creating backup...${NC}"
if [[ -f "$CUSTOM_MAIN" ]]; then
    cp "$CUSTOM_MAIN" "$CUSTOM_MAIN.backup.$(date +%s)"
    echo -e "${GREEN}✓ Backup created${NC}"
fi

echo -e "${YELLOW}Reorganizing entries...${NC}"

# Create new 40_custom with submenu structure
cat > "$CUSTOM_MAIN" << 'EOFCUSTOM'
#!/bin/bash
exec tail -n +3 $0

# === ARCH LINUX SUBMENU ===
submenu 'Arch Linux' {
    menuentry 'Arch Linux' {
        search --no-floppy --label Arch --set root
        echo 'Loading Arch Linux...'
        linux /boot/vmlinuz-linux root=/dev/mapper/arch-root rw
        initrd /boot/initramfs-linux.img
    }
    
    submenu 'Advanced options for Arch Linux' {
        menuentry 'Arch Linux (Fallback)' {
            search --no-floppy --label Arch --set root
            echo 'Loading Arch Linux (Fallback)...'
            linux /boot/vmlinuz-linux root=/dev/mapper/arch-root rw
            initrd /boot/initramfs-linux-fallback.img
        }
    }
    
    menuentry 'Arch Linux snapshots' {
        echo 'Arch Linux snapshots'
    }
}

# === WINDOWS JOKE SUBMENU (BSOD) ===
submenu 'Windows' {
    menuentry 'Windows (Press ESC to escape)' {
        # No boot command - BSOD joke entry
        # User stuck until ESC is pressed
        true
    }
}

# === FIRMWARE SETTINGS (Keep in main menu) ===
if [ "${grub_platform}" = "efi" ]; then
    menuentry 'UEFI Firmware Settings' --id uefi-firmware {
        fwsetup
    }
fi
EOFCUSTOM

chmod +x "$CUSTOM_MAIN"
echo -e "${GREEN}✓ Entries reorganized${NC}"

echo ""
echo -e "${YELLOW}Regenerating GRUB configuration...${NC}"
if grub-mkconfig -o /boot/grub/grub.cfg; then
    echo -e "${GREEN}✓ GRUB regenerated successfully${NC}"
else
    echo -e "${RED}✗ GRUB regeneration failed${NC}"
    echo -e "${YELLOW}Restoring backup...${NC}"
    cp "$CUSTOM_MAIN.backup" "$CUSTOM_MAIN"
    exit 1
fi

echo ""
echo -e "${GREEN}=== Entry reorganization complete! ===${NC}"
echo ""
echo -e "${YELLOW}Boot structure is now:${NC}"
echo "  Main Menu (Matrix Theme)"
echo "  ├─ Arch Linux (submenu with DedSec theme)"
echo "  │  ├─ Arch Linux"
echo "  │  ├─ Advanced options for Arch Linux"
echo "  │  │  └─ Arch Linux (Fallback)"
echo "  │  └─ Arch Linux snapshots"
echo "  ├─ Windows (BSOD joke, press ESC to escape)"
echo "  └─ UEFI Firmware Settings"
echo ""
echo -e "${YELLOW}Ready to reboot? (y/n)${NC}"
read -p "Reboot now? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    reboot
else
    echo -e "${YELLOW}Reboot when ready with: sudo reboot${NC}"
fi

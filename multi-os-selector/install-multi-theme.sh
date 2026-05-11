#!/bin/bash
# =============================
# Multi-OS Selector GRUB Theme Installer
# Installation script for Arch Linux
# =============================

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
THEME_NAME="multi-os-selector"
GRUB_THEME_DIR="/boot/grub/themes/$THEME_NAME"
GRUB_DEFAULT_FILE="/etc/default/grub"
GRUB_CONFIG_FILE="/boot/grub/grub.cfg"
GRUB_D_DIR="/etc/grub.d"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${GREEN}=== Multi-OS Selector GRUB Theme Installer ===${NC}"
echo ""

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}This script must be run as root!${NC}"
   echo "Please run: sudo $0"
   exit 1
fi

echo -e "${YELLOW}Step 1: Validating system...${NC}"
# Check if GRUB is installed
if ! command -v grub-mkconfig &> /dev/null; then
    echo -e "${RED}GRUB is not installed or grub-mkconfig not found${NC}"
    exit 1
fi
echo -e "${GREEN}✓ GRUB found${NC}"

# Check if on Arch Linux
if ! grep -q "Arch" /etc/os-release 2>/dev/null; then
    echo -e "${YELLOW}⚠ Warning: This does not appear to be Arch Linux${NC}"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Check if boot directory exists
if [[ ! -d "/boot/grub" ]]; then
    echo -e "${RED}GRUB directory not found at /boot/grub${NC}"
    exit 1
fi
echo -e "${GREEN}✓ GRUB directories found${NC}"

echo ""
echo -e "${YELLOW}Step 2: Creating theme directory...${NC}"
if [[ -d "$GRUB_THEME_DIR" ]]; then
    echo -e "${YELLOW}Theme directory already exists. Backing up...${NC}"
    mv "$GRUB_THEME_DIR" "$GRUB_THEME_DIR.backup.$(date +%s)"
fi
mkdir -p "$GRUB_THEME_DIR"
echo -e "${GREEN}✓ Theme directory created: $GRUB_THEME_DIR${NC}"

echo ""
echo -e "${YELLOW}Step 3: Copying theme files...${NC}"
# Copy theme configuration files
cp "$SCRIPT_DIR/theme-matrix-main.txt" "$GRUB_THEME_DIR/"
cp "$SCRIPT_DIR/theme-dedsec.txt" "$GRUB_THEME_DIR/"
cp "$SCRIPT_DIR/theme-windows-bsod.txt" "$GRUB_THEME_DIR/"
echo -e "${GREEN}✓ Theme files copied${NC}"

echo ""
echo -e "${YELLOW}Step 4: Copying fonts...${NC}"
mkdir -p "$GRUB_THEME_DIR/fonts"
# Copy Matrix font
MATRIX_FONT_LOCAL="$SCRIPT_DIR/fonts/font.pf2"
MATRIX_FONT_SRC="$SCRIPT_DIR/../github/Matrix-Morpheus-GRUB-Theme/Matrix/font.pf2"
if [[ -f "$MATRIX_FONT_LOCAL" ]]; then
    cp "$MATRIX_FONT_LOCAL" "$GRUB_THEME_DIR/"
    echo -e "${GREEN}✓ Matrix font copied from local bundle${NC}"
elif [[ -f "$MATRIX_FONT_SRC" ]]; then
    cp "$MATRIX_FONT_SRC" "$GRUB_THEME_DIR/"
    echo -e "${GREEN}✓ Matrix font copied from github reference${NC}"
else
    echo -e "${YELLOW}⚠ Matrix font not found in local bundle or github reference - skipping${NC}"
fi

# Copy DedSec fonts (if available). If not found, warn and continue.
DEDSEC_FONTS_LOCAL="$SCRIPT_DIR/fonts"
DEDSEC_FONTS_DIR="$SCRIPT_DIR/../github/dedsec-grub2-theme/assets/fonts/1080p"
if [[ -d "$DEDSEC_FONTS_LOCAL" ]] && compgen -G "$DEDSEC_FONTS_LOCAL/*.pf2" >/dev/null; then
    cp "$DEDSEC_FONTS_LOCAL/"*.pf2 "$GRUB_THEME_DIR/fonts/" 2>/dev/null || true
    echo -e "${GREEN}✓ DedSec fonts copied from local bundle${NC}"
elif [[ -d "$DEDSEC_FONTS_DIR" ]] && compgen -G "$DEDSEC_FONTS_DIR/*.pf2" >/dev/null; then
    cp "$DEDSEC_FONTS_DIR/"*.pf2 "$GRUB_THEME_DIR/fonts/" 2>/dev/null || true
    echo -e "${GREEN}✓ DedSec fonts copied from github reference${NC}"
else
    echo -e "${YELLOW}⚠ DedSec fonts not found in local bundle or github reference - skipping${NC}"
fi

echo ""
echo -e "${YELLOW}Step 5: Copying image assets...${NC}"
mkdir -p "$GRUB_THEME_DIR/assets"

# Copy bluescreen image
cp "$SCRIPT_DIR/../assets/bluescreen.png" "$GRUB_THEME_DIR/"
echo -e "${GREEN}✓ Bluescreen image copied${NC}"

# Copy Matrix background
if [[ -f "$SCRIPT_DIR/../github/Matrix-Morpheus-GRUB-Theme/Matrix/os_arch.png" ]]; then
    cp "$SCRIPT_DIR/../github/Matrix-Morpheus-GRUB-Theme/Matrix/os_arch.png" "$GRUB_THEME_DIR/matrix-background.png"
    echo -e "${GREEN}✓ Matrix background copied${NC}"
else
    echo -e "${YELLOW}⚠ Matrix background not found, using fallback${NC}"
fi

# Copy DedSec background if available
if find "$SCRIPT_DIR/../github/dedsec-grub2-theme/assets/backgrounds" -name "*.png" -print -quit | grep -q .; then
    DEDSEC_BG=$(find "$SCRIPT_DIR/../github/dedsec-grub2-theme/assets/backgrounds" -name "*.png" -print -quit | head -1)
    cp "$DEDSEC_BG" "$GRUB_THEME_DIR/dedsec-background.png"
    echo -e "${GREEN}✓ DedSec background copied${NC}"
else
    echo -e "${YELLOW}⚠ DedSec background not found${NC}"
fi

# Copy DedSec icons if available
if [[ -d "$SCRIPT_DIR/../github/dedsec-grub2-theme/assets/icons-1080p/color" ]]; then
    mkdir -p "$GRUB_THEME_DIR/assets/icons"
    cp "$SCRIPT_DIR/../github/dedsec-grub2-theme/assets/icons-1080p/color/"*.png "$GRUB_THEME_DIR/assets/icons/" 2>/dev/null || true
    echo -e "${GREEN}✓ DedSec icons copied${NC}"
fi

echo ""
echo -e "${YELLOW}Step 6: Updating GRUB configuration...${NC}"

# Backup original grub config
if [[ ! -f "$GRUB_DEFAULT_FILE.backup" ]]; then
    cp "$GRUB_DEFAULT_FILE" "$GRUB_DEFAULT_FILE.backup"
    echo -e "${GREEN}✓ Backup created: $GRUB_DEFAULT_FILE.backup${NC}"
fi

# Update GRUB_THEME if it exists, otherwise add it
if grep -q "^GRUB_THEME=" "$GRUB_DEFAULT_FILE"; then
    sed -i "s|^GRUB_THEME=.*|GRUB_THEME=\"/boot/grub/themes/$THEME_NAME/theme-matrix-main.txt\"|" "$GRUB_DEFAULT_FILE"
    echo -e "${GREEN}✓ Updated existing GRUB_THEME setting${NC}"
else
    echo "GRUB_THEME=\"/boot/grub/themes/$THEME_NAME/theme-matrix-main.txt\"" >> "$GRUB_DEFAULT_FILE"
    echo -e "${GREEN}✓ Added GRUB_THEME setting${NC}"
fi

# Ensure terminal output is not console (graphical mode)
if grep -q "^GRUB_TERMINAL_OUTPUT=" "$GRUB_DEFAULT_FILE"; then
    sed -i '/^GRUB_TERMINAL_OUTPUT=/d' "$GRUB_DEFAULT_FILE"
    echo -e "${GREEN}✓ Removed GRUB_TERMINAL_OUTPUT constraint${NC}"
fi

# Set menu timeout style
if grep -q "^GRUB_TIMEOUT_STYLE=" "$GRUB_DEFAULT_FILE"; then
    sed -i 's/^GRUB_TIMEOUT_STYLE=.*/GRUB_TIMEOUT_STYLE=menu/' "$GRUB_DEFAULT_FILE"
else
    echo "GRUB_TIMEOUT_STYLE=menu" >> "$GRUB_DEFAULT_FILE"
fi
echo -e "${GREEN}✓ GRUB_TIMEOUT_STYLE set to menu${NC}"

echo ""
echo -e "${YELLOW}Step 7: Regenerating GRUB configuration...${NC}"
if grub-mkconfig -o /boot/grub/grub.cfg; then
    echo -e "${GREEN}✓ GRUB configuration regenerated successfully${NC}"
else
    echo -e "${RED}✗ Failed to regenerate GRUB configuration${NC}"
    echo -e "${YELLOW}Restoring backup...${NC}"
    cp "$GRUB_DEFAULT_FILE.backup" "$GRUB_DEFAULT_FILE"
    exit 1
fi

echo ""
echo -e "${GREEN}=== Installation Complete! ===${NC}"
echo ""
echo -e "${YELLOW}Summary:${NC}"
echo "  Theme directory: $GRUB_THEME_DIR"
echo "  GRUB config: $GRUB_DEFAULT_FILE"
echo ""
echo -e "${YELLOW}What you'll see on next boot:${NC}"
echo "  1. Matrix menu appears (main OS selection)"
echo "  2. Select 'Arch Linux' → DedSec theme with Arch boot options"
echo "  3. Select 'Windows' → Blue Screen of Death (joke, press ESC to escape)"
echo "  4. Press ESC from any submenu → Return to Matrix menu"
echo ""
echo -e "${GREEN}Ready to reboot? (y/n)${NC}"
read -p "Reboot now? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    reboot
else
    echo -e "${YELLOW}Installation complete. Reboot when ready with: sudo reboot${NC}"
fi

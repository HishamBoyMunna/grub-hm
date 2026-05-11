#!/bin/bash
# revert-grub.sh
# Restore original GRUB configuration and optionally remove the installed theme
# Usage: sudo bash revert-grub.sh

set -euo pipefail

THEME_DIR="/boot/grub/themes/multi-os-selector"
GRUB_DEFAULT="/etc/default/grub"
BACKUP="${GRUB_DEFAULT}.backup"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

if [[ $EUID -ne 0 ]]; then
  echo -e "${RED}This script must be run as root. Use: sudo $0${NC}"
  exit 1
fi

echo -e "${YELLOW}Revert GRUB to original state helper${NC}"

# Check for backup
if [[ ! -f "$BACKUP" ]]; then
  echo -e "${RED}Backup not found: $BACKUP${NC}"
  echo "If you created a manual backup, restore it manually. Aborting." 
  exit 1
fi

read -p "Restore /etc/default/grub from backup ($BACKUP)? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Aborted by user. No changes made." 
  exit 0
fi

# Restore default grub file
cp "$BACKUP" "$GRUB_DEFAULT"
chmod 644 "$GRUB_DEFAULT"

echo -e "${GREEN}Restored $GRUB_DEFAULT from backup.${NC}"

# Regenerate grub config
echo -e "${YELLOW}Regenerating GRUB configuration...${NC}"
if grub-mkconfig -o /boot/grub/grub.cfg; then
  echo -e "${GREEN}Successfully regenerated /boot/grub/grub.cfg${NC}"
else
  echo -e "${RED}Failed to regenerate GRUB configuration. Please inspect /etc/default/grub and run grub-mkconfig manually.${NC}"
  exit 1
fi

# Optionally remove theme files
if [[ -d "$THEME_DIR" ]]; then
  read -p "Remove theme directory $THEME_DIR? (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -rf "$THEME_DIR"
    echo -e "${GREEN}Removed theme directory: $THEME_DIR${NC}"
  else
    echo "Theme directory left intact: $THEME_DIR"
  fi
else
  echo "No theme directory found at $THEME_DIR"
fi

echo -e "${GREEN}Revert complete. Reboot when ready: sudo reboot${NC}"

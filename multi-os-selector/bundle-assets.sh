#!/usr/bin/env bash
# bundle-assets.sh
# Collect required fonts and images into the local `multi-os-selector` bundle

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Bundling assets into: $SCRIPT_DIR"

mkdir -p "$SCRIPT_DIR/fonts"
mkdir -p "$SCRIPT_DIR/assets"

# Matrix font
MATRIX_SRC="$SCRIPT_DIR/../github/Matrix-Morpheus-GRUB-Theme/Matrix/font.pf2"
if [[ -f "$MATRIX_SRC" ]]; then
    cp -v "$MATRIX_SRC" "$SCRIPT_DIR/fonts/font.pf2"
else
    echo "Warning: Matrix font not found at $MATRIX_SRC"
fi

# DedSec fonts (1080p)
DEDSEC_FONTS_SRC_DIR="$SCRIPT_DIR/../github/dedsec-grub2-theme/assets/fonts/1080p"
if [[ -d "$DEDSEC_FONTS_SRC_DIR" ]] && compgen -G "$DEDSEC_FONTS_SRC_DIR/*.pf2" >/dev/null; then
    cp -v "$DEDSEC_FONTS_SRC_DIR/"*.pf2 "$SCRIPT_DIR/fonts/"
else
    echo "Warning: DedSec fonts not found at $DEDSEC_FONTS_SRC_DIR"
fi

# Bluescreen image (from workspace assets)
if [[ -f "$SCRIPT_DIR/../assets/bluescreen.png" ]]; then
    cp -v "$SCRIPT_DIR/../assets/bluescreen.png" "$SCRIPT_DIR/assets/bluescreen.png"
else
    echo "Warning: bluescreen.png not found in workspace assets"
fi

# Matrix and DedSec backgrounds - try to copy if present
if [[ -f "$SCRIPT_DIR/../github/Matrix-Morpheus-GRUB-Theme/Matrix/os_arch.png" ]]; then
    cp -v "$SCRIPT_DIR/../github/Matrix-Morpheus-GRUB-Theme/Matrix/os_arch.png" "$SCRIPT_DIR/assets/matrix-background.png"
fi

DEDSEC_BG_DIR="$SCRIPT_DIR/../github/dedsec-grub2-theme/assets/backgrounds"
if find "$DEDSEC_BG_DIR" -name "*.png" -print -quit | grep -q .; then
    DEDSEC_BG=$(find "$DEDSEC_BG_DIR" -name "*.png" -print -quit | head -1)
    cp -v "$DEDSEC_BG" "$SCRIPT_DIR/assets/dedsec-background.png"
fi

echo "Bundle complete. Local bundle contents:"
ls -la "$SCRIPT_DIR/fonts" || true
ls -la "$SCRIPT_DIR/assets" || true

echo "Now run: sudo bash install-multi-theme.sh"

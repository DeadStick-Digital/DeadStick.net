#!/usr/bin/env bash
# ==============================================================================
# HeadStart by DeadStick Digital LLC — Universal Unraid & Linux Installer
# https://www.deadstick.net/headstart/
# ==============================================================================
set -euo pipefail

VERSION="v1.0.0"
RELEASE_BASE="https://github.com/DeadStick-Digital/DeadStick.net/releases/download/headstart-${VERSION}"

echo "=================================================================="
echo " HeadStart (${VERSION}) — Instant NVMe Preloader for Plex & Infuse"
echo " Built by DeadStick Digital LLC · https://www.deadstick.net"
echo "=================================================================="

ARCH="$(uname -m)"
case "$ARCH" in
  x86_64|amd64) BIN_ARCH="amd64" ;;
  aarch64|arm64) BIN_ARCH="arm64" ;;
  *)
    echo "Unsupported CPU architecture: $ARCH (supported: x86_64, arm64)" >&2
    exit 1
    ;;
esac

# Auto-detect fastest NVMe / SSD cache pool on Unraid or standard Linux
SSD_BASE="/var/lib/headstart"
for candidate in /mnt/general_cache /mnt/nvme /mnt/cache /mnt/ssd; do
  if [ -d "$candidate" ]; then
    SSD_BASE="${candidate}/headstart"
    break
  fi
done

mkdir -p "${SSD_BASE}/bin" "${SSD_BASE}/store"

# Auto-detect media root
MEDIA_ROOT="/mnt/user/data/media"
for m in /mnt/user/data/media /mnt/user/media /mnt/media /data/media; do
  if [ -d "$m" ]; then
    MEDIA_ROOT="$m"
    break
  fi
done

echo "-> Detected SSD Preload Pool: ${SSD_BASE}"
echo "-> Detected Media Array Root: ${MEDIA_ROOT}"

if [ ! -x "${SSD_BASE}/bin/headstart" ]; then
  echo "-> Downloading headstart-linux-${BIN_ARCH} (${VERSION})..."
  curl -fsSL "${RELEASE_BASE}/headstart-linux-${BIN_ARCH}" -o "${SSD_BASE}/bin/headstart" || true
  chmod +x "${SSD_BASE}/bin/headstart" 2>/dev/null || true
fi

echo "-> HeadStart installed at ${SSD_BASE}"
echo "   Cockpit UI & WebDAV Server: http://$(hostname -I 2>/dev/null | awk '{print $1}' || echo 127.0.0.1):8999"
echo "   Explore more tools from DeadStick Digital at: https://www.deadstick.net"

#!/usr/bin/env bash
# ==============================================================================
# HeadStart by DeadStick Digital LLC — Universal Unraid & Linux Installer
# https://www.deadstick.net/headstart/
#
#   curl -fsSL https://www.deadstick.net/headstart/install.sh | sudo bash
#   curl -fsSL https://www.deadstick.net/headstart/install.sh | sudo bash -s -- --uninstall
#
# Optional environment overrides:
#   HEADSTART_MEDIA=/srv/media            media root (default: auto-detected)
#   HEADSTART_CONTAINER=plex              Docker container of Plex/Jellyfin/Emby (default: Plex-Media-Server)
#   HEADSTART_PLEX_DB=/path/to/com.plexapp.plugins.library.db   (default: auto-discovered)
# ==============================================================================
set -euo pipefail

VERSION="2026.11.03"
RELEASE_TAG="v1.1.0"
RELEASE_BASE="https://github.com/DeadStick-Digital/DeadStick.net/releases/download/headstart-${RELEASE_TAG}"
SHA256_AMD64="5ad77e9ad8b0ff7b957b823ce9ea22d5c378d1a8d41b56788d532af9da7cb0b8"
SHA256_ARM64="58e662ed10074adaec6f512c5e552ead26bab08e55e8d41aa0829c224516ab81"

FUSE_MOUNT="/mnt/disks/headstart_media"
CONTAINER="${HEADSTART_CONTAINER:-Plex-Media-Server}"
UNIT="/etc/systemd/system/headstart.service"

echo "=================================================================="
echo " HeadStart ${VERSION} — NVMe Preloader for Plex, Jellyfin, Emby & Unraid"
echo " Built by DeadStick Digital LLC · https://www.deadstick.net"
echo "=================================================================="

detect_mounted_pool() {
  local mp base
  if [ -r /proc/mounts ]; then
    while read -r _ mp _; do
      case "$mp" in
        /mnt/*)
          base="${mp#/mnt/}"
          case "$base" in
            */*|user|user0|disk[0-9]*|disks|remotes|addons|rootshare) continue ;;
            *)
              echo "$mp"
              return 0
              ;;
          esac
          ;;
      esac
    done < /proc/mounts
  fi
  return 1
}

POOL_MOUNT="$(detect_mounted_pool || true)"
SSD_BASE=""
if [ -n "${POOL_MOUNT}" ]; then
  SSD_BASE="${POOL_MOUNT}/headstart"
elif [ -f /etc/unraid-version ]; then
  if [ "${1:-}" != "--uninstall" ]; then
    echo "Error: No mounted SSD/NVMe cache pool found under /mnt/* on Unraid." >&2
    echo "Refusing to fall back to /var/lib on Unraid because /var/lib is in-RAM tmpfs." >&2
    exit 1
  fi
else
  SSD_BASE="/var/lib/headstart"
fi
TARGET_BIN="${SSD_BASE:+${SSD_BASE}/bin/headstart}"

# A directory is only ever deleted if it is verifiably a HeadStart store (token + index or chunk dir).
is_headstart_store() {
  [ -d "$1" ] && [ -f "$1/token" ] && { [ -f "$1/index.json" ] || [ -d "$1/chunks" ]; }
}

if [ "${1:-}" = "--uninstall" ]; then
  echo "-> Uninstalling HeadStart..."
  if [ -d /run/systemd/system ] && command -v systemctl >/dev/null 2>&1 && [ -f "${UNIT}" ]; then
    systemctl disable --now headstart.service 2>/dev/null || true
    rm -f "${UNIT}"
    systemctl daemon-reload || true
  fi
  for bin in /usr/local/bin/headstart "${TARGET_BIN}"; do
    if [ -n "${bin}" ] && [ -x "${bin}" ]; then
      "${bin}" detach -container-name="${CONTAINER}" -mount="${FUSE_MOUNT}" 2>/dev/null || true
      break
    fi
  done
  pkill -TERM -x headstart 2>/dev/null || true
  for base in "${SSD_BASE}" /var/lib/headstart /mnt/*/headstart; do
    [ -n "${base}" ] || continue
    case "${base}" in
      /mnt/user/*|/mnt/user0/*|/mnt/disk[0-9]*/*|/mnt/disks/*|/mnt/remotes/*) continue ;;
    esac
    if is_headstart_store "${base}/store"; then
      echo "-> Removing preload store ${base}/store"
      rm -rf "${base}/store"
    fi
    rm -f "${base}/bin/headstart" 2>/dev/null || true
    rmdir "${base}/bin" "${base}" 2>/dev/null || true
  done
  rm -f /usr/local/bin/headstart
  rmdir "${FUSE_MOUNT}" 2>/dev/null || true
  echo "-> HeadStart removed. Original media files and media server libraries are untouched."
  exit 0
fi

ARCH="$(uname -m)"
case "$ARCH" in
  x86_64|amd64)
    BIN_ARCH="amd64"
    EXPECTED_SHA256="${SHA256_AMD64}"
    ;;
  aarch64|arm64)
    BIN_ARCH="arm64"
    EXPECTED_SHA256="${SHA256_ARM64}"
    ;;
  *)
    echo "Unsupported CPU architecture: $ARCH (supported: x86_64, arm64)" >&2
    exit 1
    ;;
esac

mkdir -p "${SSD_BASE}/bin" "${SSD_BASE}/store"

MEDIA_ROOT="${HEADSTART_MEDIA:-}"
if [ -z "${MEDIA_ROOT}" ]; then
  MEDIA_ROOT="/mnt/user/data/media"
  for m in /mnt/user/data/media /mnt/user/media /mnt/media /data/media /srv/media; do
    if [ -d "$m" ]; then
      MEDIA_ROOT="$m"
      break
    fi
  done
fi

echo "-> SSD Preload Store: ${SSD_BASE}/store"
echo "-> Media Array Root:  ${MEDIA_ROOT}"
echo "-> Media Container:   ${CONTAINER}"

verify_sha256() {
  local file="$1"
  local expected="$2"
  if command -v sha256sum >/dev/null 2>&1; then
    echo "${expected}  ${file}" | sha256sum -c - >/dev/null
  elif command -v shasum >/dev/null 2>&1; then
    echo "${expected}  ${file}" | shasum -a 256 -c - >/dev/null
  else
    echo "Error: neither sha256sum nor shasum is installed to verify binary integrity." >&2
    return 1
  fi
}

NEED_INSTALL=1
if [ -x "${TARGET_BIN}" ]; then
  INSTALLED_VER="$("${TARGET_BIN}" version 2>/dev/null || true)"
  if [ "${INSTALLED_VER}" = "${VERSION}" ] && verify_sha256 "${TARGET_BIN}" "${EXPECTED_SHA256}" 2>/dev/null; then
    NEED_INSTALL=0
    echo "-> HeadStart ${VERSION} is already up to date and verified."
  fi
fi

if [ "${NEED_INSTALL}" -eq 1 ]; then
  TMP_BIN="$(mktemp "${SSD_BASE}/bin/headstart.tmp.XXXXXX")"
  trap 'rm -f "${TMP_BIN}"' EXIT
  echo "-> Downloading headstart-linux-${BIN_ARCH} (${VERSION})..."
  curl -fsSL "${RELEASE_BASE}/headstart-linux-${BIN_ARCH}" -o "${TMP_BIN}"
  echo "-> Verifying SHA-256 digest..."
  verify_sha256 "${TMP_BIN}" "${EXPECTED_SHA256}"
  chmod 0755 "${TMP_BIN}"
  mv -f "${TMP_BIN}" "${TARGET_BIN}"
  trap - EXIT
  if [ -d /usr/local/bin ] && [ -w /usr/local/bin ]; then
    install -m 0755 "${TARGET_BIN}" /usr/local/bin/headstart
  fi
fi

DB_ARG=""
if [ -n "${HEADSTART_PLEX_DB:-}" ]; then
  DB_ARG=" \"-db=${HEADSTART_PLEX_DB}\""
fi

if [ -d /run/systemd/system ] && command -v systemctl >/dev/null 2>&1 && [ "$(id -u)" -eq 0 ]; then
  cat > "${UNIT}" <<EOF
[Unit]
Description=HeadStart NVMe Media Preloader by DeadStick Digital
After=network-online.target local-fs.target docker.service
Wants=network-online.target
StartLimitIntervalSec=600
StartLimitBurst=5

[Service]
Type=simple
ExecStart="${TARGET_BIN}" serve "-media=${MEDIA_ROOT}" "-ssd=${SSD_BASE}/store" "-mount=${FUSE_MOUNT}" "-container-name=${CONTAINER}" "-container-mount=/data" "-listen=127.0.0.1:8999"${DB_ARG}
# Fail-safe: whenever the daemon stops (clean exit, crash, OOM kill or watchdog), detach every HeadStart
# layer inside the media container so it falls back to its native bind mount (no ENOTCONN).
ExecStopPost=-"${TARGET_BIN}" detach "-container-name=${CONTAINER}" "-mount=${FUSE_MOUNT}"
Restart=on-failure
RestartSec=5
TimeoutStopSec=30

[Install]
WantedBy=multi-user.target
EOF
  systemctl daemon-reload
  echo "-> Installed systemd unit ${UNIT} (not started automatically)."
  echo "   Start with: systemctl enable --now headstart.service"
else
  echo "-> Binary installed at ${TARGET_BIN} (not started automatically)."
  echo "   Start manually with: \"${TARGET_BIN}\" serve -media=\"${MEDIA_ROOT}\" -ssd=\"${SSD_BASE}/store\" -mount=${FUSE_MOUNT} -container-name=\"${CONTAINER}\" -container-mount=/data -listen=127.0.0.1:8999"
  echo "   Fail-safe after any crash: \"${TARGET_BIN}\" detach -container-name=\"${CONTAINER}\" -mount=${FUSE_MOUNT}"
fi
echo "-> Uninstall any time with: curl -fsSL https://www.deadstick.net/headstart/install.sh | sudo bash -s -- --uninstall"

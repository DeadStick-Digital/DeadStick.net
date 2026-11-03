#!/usr/bin/env bash
# ==============================================================================
# HeadStart by DeadStick Digital LLC — Universal Unraid & Linux Installer
# https://www.deadstick.net/headstart/
# ==============================================================================
set -euo pipefail

VERSION="2026.11.02"
RELEASE_TAG="v1.0.0"
RELEASE_BASE="https://github.com/DeadStick-Digital/DeadStick.net/releases/download/headstart-${RELEASE_TAG}"
SHA256_AMD64="a56c37759fb3dc7936e87aa5a1b7006b923a3e3373fe702dfe09c8672433689b"
SHA256_ARM64="b07e94facae970661a36a41c683542150f7adcf8a1846eb4969f3fb840cb2183"

echo "=================================================================="
echo " HeadStart ${VERSION} — NVMe Preloader for Plex, Infuse & Unraid"
echo " Built by DeadStick Digital LLC · https://www.deadstick.net"
echo "=================================================================="

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
  echo "Error: No mounted SSD/NVMe cache pool found under /mnt/* on Unraid." >&2
  echo "Refusing to fall back to /var/lib on Unraid because /var/lib is in-RAM tmpfs." >&2
  exit 1
else
  SSD_BASE="/var/lib/headstart"
fi

mkdir -p "${SSD_BASE}/bin" "${SSD_BASE}/store"

MEDIA_ROOT="/mnt/user/data/media"
for m in /mnt/user/data/media /mnt/user/media /mnt/media /data/media /srv/media; do
  if [ -d "$m" ]; then
    MEDIA_ROOT="$m"
    break
  fi
done

echo "-> SSD Preload Store: ${SSD_BASE}/store"
echo "-> Media Array Root:  ${MEDIA_ROOT}"

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

TARGET_BIN="${SSD_BASE}/bin/headstart"
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

if [ -d /run/systemd/system ] && command -v systemctl >/dev/null 2>&1 && [ "$(id -u)" -eq 0 ]; then
  cat > /etc/systemd/system/headstart.service <<EOF
[Unit]
Description=HeadStart NVMe Media Preloader by DeadStick Digital
After=network.target local-fs.target

[Service]
Type=simple
ExecStart=${TARGET_BIN} serve -media=${MEDIA_ROOT} -ssd=${SSD_BASE}/store -listen=127.0.0.1:8999
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
  systemctl daemon-reload
  echo "-> Installed systemd unit /etc/systemd/system/headstart.service (not started automatically)."
  echo "   Start with: systemctl enable --now headstart.service"
else
  echo "-> Binary installed at ${TARGET_BIN} (not started automatically)."
  echo "   Start manually with: ${TARGET_BIN} serve -media=${MEDIA_ROOT} -ssd=${SSD_BASE}/store -listen=127.0.0.1:8999"
fi

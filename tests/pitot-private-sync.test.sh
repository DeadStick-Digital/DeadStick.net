#!/usr/bin/env bash
set -euo pipefail

require() {
  local pattern="$1"
  local file="$2"
  local message="$3"

  if ! git grep -q "$pattern" -- "$file"; then
    printf 'Missing expected Voyage Vault private-sync copy: %s\n' "$message" >&2
    exit 1
  fi
}

require 'Use planned private sync to access your document vault through your own iCloud or Google Drive account across supported devices' \
  apps/pitot.html \
  'Voyage Vault capability list should explain iCloud and Google Drive account access'

#!/usr/bin/env bash
set -euo pipefail

require() {
  local pattern="$1"
  local file="$2"
  local message="$3"

  if ! git grep -q "$pattern" -- "$file"; then
    printf 'Missing expected CryptScan security highlight: %s\n' "$message" >&2
    exit 1
  fi
}

require '<h3>Security measures</h3>' \
  apps/cryptscan.html \
  'CryptScan detail page should introduce the security measures section'

require 'styles.css?v=20260612-cryptscan' \
  apps/cryptscan.html \
  'CryptScan detail page should request the security-highlight stylesheet update'

require 'Documents stay local by default' \
  apps/cryptscan.html \
  'Security highlights should lead with local-first storage'

require 'No proprietary CryptScan document server' \
  apps/cryptscan.html \
  'Security highlights should call out the avoided backend'

require 'On-device OCR and search indexes' \
  apps/cryptscan.html \
  'Security highlights should mention local OCR/indexing'

require 'SHA-256 content identity' \
  apps/cryptscan.html \
  'Security highlights should mention content-addressed asset identity'

require 'Path and symlink escape checks' \
  apps/cryptscan.html \
  'Security highlights should mention unsafe path checks'

require 'Face ID, biometrics, or a CryptScan PIN' \
  apps/cryptscan.html \
  'Security highlights should mention optional unlock controls'

require '.security-measures' \
  styles.css \
  'Security highlights should have dedicated visual treatment'

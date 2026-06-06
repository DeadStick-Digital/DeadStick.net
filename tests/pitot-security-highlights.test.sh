#!/usr/bin/env bash
set -euo pipefail

require() {
  local pattern="$1"
  local file="$2"
  local message="$3"

  if ! git grep -q "$pattern" -- "$file"; then
    printf 'Missing expected Voyage Vault security highlight: %s\n' "$message" >&2
    exit 1
  fi
}

require '<h3>Security measures</h3>' \
  apps/pitot.html \
  'Voyage Vault detail page should introduce the security measures section'

require 'styles.css?v=20260606-voyage-vault' \
  apps/pitot.html \
  'Voyage Vault detail page should request the security-highlight stylesheet update'

require 'Documents stay local by default' \
  apps/pitot.html \
  'Security highlights should lead with local-first storage'

require 'No proprietary Voyage Vault document server' \
  apps/pitot.html \
  'Security highlights should call out the avoided backend'

require 'On-device OCR and search indexes' \
  apps/pitot.html \
  'Security highlights should mention local OCR/indexing'

require 'SHA-256 content identity' \
  apps/pitot.html \
  'Security highlights should mention content-addressed asset identity'

require 'Path and symlink escape checks' \
  apps/pitot.html \
  'Security highlights should mention unsafe path checks'

require 'Face ID, biometrics, or a Voyage Vault PIN' \
  apps/pitot.html \
  'Security highlights should mention optional unlock controls'

require '.security-measures' \
  styles.css \
  'Security highlights should have dedicated visual treatment'

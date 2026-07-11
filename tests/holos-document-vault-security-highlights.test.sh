#!/usr/bin/env bash
set -euo pipefail

require() {
  local pattern="$1"
  local file="$2"
  local message="$3"

  if ! git grep -q "$pattern" -- "$file"; then
    printf 'Missing expected Document Vault security highlight: %s\n' "$message" >&2
    exit 1
  fi
}

require '<h3>Security measures</h3>' \
  apps/holos-document-vault.html \
  'Document Vault detail page should introduce the security measures section'

require 'styles.css?v=20260711-document-vault-branding' \
  apps/holos-document-vault.html \
  'Document Vault detail page should request the branding stylesheet update'

require 'Documents stay local by default' \
  apps/holos-document-vault.html \
  'Security highlights should lead with local-first storage'

require 'No proprietary Document Vault document server' \
  apps/holos-document-vault.html \
  'Security highlights should call out the avoided backend'

require 'On-device OCR and search indexes' \
  apps/holos-document-vault.html \
  'Security highlights should mention local OCR/indexing'

require 'SHA-256 content identity' \
  apps/holos-document-vault.html \
  'Security highlights should mention content-addressed asset identity'

require 'Path and symlink escape checks' \
  apps/holos-document-vault.html \
  'Security highlights should mention unsafe path checks'

require 'Face ID, biometrics, or a Document Vault PIN' \
  apps/holos-document-vault.html \
  'Security highlights should mention optional unlock controls'

require '.security-measures' \
  styles.css \
  'Security highlights should have dedicated visual treatment'

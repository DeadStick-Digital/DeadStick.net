#!/usr/bin/env bash
set -euo pipefail

require() {
  local pattern="$1"
  local file="$2"
  local message="$3"

  if ! git grep -q "$pattern" -- "$file"; then
    printf 'Missing expected homepage card branding: %s\n' "$message" >&2
    exit 1
  fi
}

reject() {
  local pattern="$1"
  local file="$2"
  local message="$3"

  if git grep -q "$pattern" -- "$file"; then
    printf 'Unexpected homepage card branding remains: %s\n' "$message" >&2
    exit 1
  fi
}

require '<h3>Drive Vault</h3>' index.html \
  'Drive Vault should use its simplified display name'
require '<h3>Document Vault</h3>' index.html \
  'Document Vault should use its simplified display name'
reject '<h3>Holos Drive Vault</h3>' index.html \
  'Holos Drive Vault should not remain as the homepage card title'
reject '<h3>Holos Document Vault</h3>' index.html \
  'Holos Document Vault should not remain as the homepage card title'

byline_count="$(grep -c '<p class="app-byline">by DeadStick</p>' index.html)"
if [[ "$byline_count" -ne 2 ]]; then
  printf 'Expected exactly two DeadStick product-card bylines, found %s\n' "$byline_count" >&2
  exit 1
fi

require '<h3>BillingBird</h3>' index.html \
  'BillingBird should remain unchanged'
require '<h3>CarrierPigeonVPN</h3>' index.html \
  'CarrierPigeonVPN should remain unchanged'
require '.app-card .app-byline {' styles.css \
  'the supporting byline should have a scoped card style'
require 'color: var(--text-soft);' styles.css \
  'the supporting byline should use the existing low-emphasis text token'

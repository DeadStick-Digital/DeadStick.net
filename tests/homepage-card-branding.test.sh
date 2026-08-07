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

document_card_line="$(grep -n 'article class="app-card is-holos-document-vault' index.html | cut -d: -f1)"
drive_card_line="$(grep -n 'article class="app-card is-holos-drive-vault' index.html | cut -d: -f1)"
if (( document_card_line >= drive_card_line )); then
  printf 'Expected Document Vault to appear before Drive Vault on the homepage\n' >&2
  exit 1
fi

reject '<h3>Holos Drive Vault</h3>' index.html \
  'Holos Drive Vault should not remain as the homepage card title'

byline_count="$(grep -c '<p class="app-byline">by DeadStick</p>' index.html)"
if [[ "$byline_count" -ne 2 ]]; then
  printf 'Expected exactly two DeadStick product-card bylines, found %s\n' "$byline_count" >&2
  exit 1
fi

require '<h3>BillingBird</h3>' index.html \
  'BillingBird should remain unchanged'
require 'For contractors &amp; service pros' index.html \
  'BillingBird homepage tag should match the approved iPhone-first positioning'
require 'Professional invoicing, receipt capture, and client balances for contractors and' index.html \
  'BillingBird homepage description should lead with the approved invoicing copy'
require 'service professionals—available now on iPhone, with records that stay on your device.' index.html \
  'BillingBird homepage description should state iPhone availability and on-device records'
require 'Available now on iPhone' index.html \
  'BillingBird homepage card should state iPhone availability'
require 'Invoices, receipts &amp; payment tracking' index.html \
  'BillingBird homepage card should list the invoices/receipts/payments feature'
require 'Privacy-first — designed to meet government NIAP &amp; FIPS practices' index.html \
  'BillingBird homepage card should carry the sanctioned privacy-first assurance line'
reject 'estimates' index.html \
  'estimates are not a BillingBird feature and must not appear on the homepage'
require 'iPadOS, macOS, Android, and Windows support is planned' index.html \
  'BillingBird homepage card should state the planned-platform roadmap'
require '>Explore BillingBird <span aria-hidden="true">→</span></a>' index.html \
  'BillingBird homepage link should clearly name its destination'
reject 'Built for iPhone, iPad &amp; Mac' index.html \
  'Retired multi-Apple current-availability claim must not remain on the homepage card'
require '<h3>CarrierPigeonVPN</h3>' index.html \
  'CarrierPigeonVPN should remain unchanged'
require '.app-card .app-byline {' styles.css \
  'the supporting byline should have a scoped card style'
require 'color: var(--text-soft);' styles.css \
  'the supporting byline should use the existing low-emphasis text token'

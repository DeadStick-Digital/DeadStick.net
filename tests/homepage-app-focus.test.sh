#!/usr/bin/env bash
set -euo pipefail

require() {
  local pattern="$1"
  local file="$2"
  local message="$3"

  if ! git grep -q "$pattern" -- "$file"; then
    printf 'Missing expected homepage focus state: %s\n' "$message" >&2
    exit 1
  fi
}

reject() {
  local pattern="$1"
  local file="$2"
  local message="$3"

  if git grep -q "$pattern" -- "$file"; then
    printf 'Unexpected homepage copy remains: %s\n' "$message" >&2
    exit 1
  fi
}

require '<article class="app-card is-billingbird is-primary-focus">' \
  index.html \
  'BillingBird should carry the primary focus state'

require '<link rel="stylesheet" href="styles.css?v=20260613-holos-drive-vault">' \
  index.html \
  'Homepage should cache-bust the stylesheet for privacy-promise copy styling'

require 'DeadStick Digital is built on a simple foundational promise: customer data belongs to' \
  index.html \
  'Studio intro should lead with the customer privacy promise'

require 'the customer. Data is never collected, monetized, inspected, or stored by the company.' \
  index.html \
  'Studio intro should continue the customer privacy promise'

require 'Data is never collected, monetized, inspected, or stored by the company.' \
  index.html \
  'Studio intro should say customer data is not collected or accessed'

require 'Our value is in our promise. All DeadStick Digital software is built with your privacy' \
  index.html \
  'Studio intro should close with the privacy-first software promise'

require 'in mind.</p>' \
  index.html \
  'Studio intro should complete the privacy-first software promise'

reject 'DeadStick Digital is a boutique software studio.' \
  index.html \
  'Old studio intro should be replaced'

reject 'We sign our own releases' \
  index.html \
  'Old studio intro should no longer use first-person wording'

reject '3</strong>Shipping apps' \
  index.html \
  'Homepage stats should not imply all three apps are shipping'

require 'grid-template-columns: repeat(4, minmax(0, 1fr));' \
  styles.css \
  'Homepage app cards should sit side-by-side on wide desktop'

require '<article class="app-card is-carrierpigeonvpn is-coming-soon" data-status="Coming soon">' \
  index.html \
  'CarrierPigeonVPN should expose the coming-soon state for the watermark'

require '<article class="app-card is-holos-drive-vault is-coming-soon" data-status="Coming soon">' \
  index.html \
  'Holos Drive Vault should expose the coming-soon state for the watermark'

require '<article class="app-card is-holos-document-vault is-coming-soon" data-status="Coming soon">' \
  index.html \
  'Holos Document Vault should expose the coming-soon state for the watermark'

require '<a class="app-icon app-icon-link" href="apps/billingbird.html" aria-label="Open BillingBird app page">' \
  index.html \
  'BillingBird icon should link to its app page'

require '<a class="app-icon app-icon-link" href="apps/carrierpigeonvpn.html" aria-label="Open CarrierPigeonVPN app page">' \
  index.html \
  'CarrierPigeonVPN icon should link to its app page'

require '<a class="app-icon app-icon-link" href="apps/holos-drive-vault.html" aria-label="Open Holos Drive Vault app page">' \
  index.html \
  'Holos Drive Vault icon should link to its app page'

require '<a class="app-icon app-icon-link" href="apps/holos-document-vault.html" aria-label="Open Holos Document Vault app page">' \
  index.html \
  'Holos Document Vault icon should link to its app page'

require '.app-card.is-coming-soon::after' \
  styles.css \
  'Coming-soon cards should render a diagonal watermark'

require '.app-card.is-coming-soon .app-icon' \
  styles.css \
  'Coming-soon styling should visually dim app artwork'

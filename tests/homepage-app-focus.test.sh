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

reject '3</strong>Shipping apps' \
  index.html \
  'Homepage stats should not imply all three apps are shipping'

require '<article class="app-card is-clawmelt is-coming-soon" data-status="Coming soon">' \
  index.html \
  'ClawMelt should expose the coming-soon state for the watermark'

require '<article class="app-card is-carrierpigeonvpn is-coming-soon" data-status="Coming soon">' \
  index.html \
  'CarrierPigeonVPN should expose the coming-soon state for the watermark'

require '.app-card.is-coming-soon::after' \
  styles.css \
  'Coming-soon cards should render a diagonal watermark'

require '.app-card.is-coming-soon .app-icon' \
  styles.css \
  'Coming-soon styling should visually dim app artwork'

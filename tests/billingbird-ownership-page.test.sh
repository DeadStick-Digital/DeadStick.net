#!/usr/bin/env bash
set -euo pipefail

PAGE="apps/billingbird.html"

[ -f "$PAGE" ] || { echo "Missing $PAGE" >&2; exit 1; }

require() {
  local pattern="$1"
  local message="$2"

  if ! grep -qF "$pattern" "$PAGE"; then
    printf 'Missing expected BillingBird ownership-page state: %s\n' "$message" >&2
    exit 1
  fi
}

reject() {
  local pattern="$1"
  local message="$2"

  if grep -qF "$pattern" "$PAGE"; then
    printf 'Outdated BillingBird primary marketing copy remains: %s\n' "$message" >&2
    exit 1
  fi
}

line_number() {
  grep -nF "$1" "$PAGE" | head -n 1 | cut -d: -f1
}

require 'The invoicing app that never owns your books.' 'Hero should lead with data ownership'
require 'DeadStick Digital has no bookkeeping server storing your data.' 'Hero should state the no-server architecture'
require 'Your business data belongs to your business.' 'Ownership explanation should lead the detail content'
require 'Company servers' 'Comparison should show the common company-server path'
require 'Your iCloud / Google Drive' 'Comparison should show personal-cloud sync'
require 'Google Drive sync is' 'Google Drive availability should be qualified'
require 'available only on supported platforms or releases.' 'Google Drive should not be presented as current on every platform'
require '<h3>Data ownership</h3>' 'Storage section should be renamed in plain language'
require '<h3>Built around ownership</h3>' 'Ownership capabilities should precede business features'
require '<h3>Built for business</h3>' 'Business capabilities should remain present'
require "<h3>Your data isn't rented.</h3>" 'Export portability should have its own highlighted section'
require '<h3>Why we built BillingBird this way</h3>' 'Product rationale should appear before accessibility'
require '<h3>Accessibility</h3>' 'Accessibility information should remain present'
require '<h3>Technical specifications</h3>' 'Implementation details should be demoted to the final section'
require '../privacy.html#apps' 'Existing BillingBird privacy link should remain available'
require '<aside class="side-card">' 'Existing app side card should remain available'

ownership_line="$(line_number 'Your business data belongs to your business.')"
built_ownership_line="$(line_number '<h3>Built around ownership</h3>')"
built_business_line="$(line_number '<h3>Built for business</h3>')"
why_line="$(line_number '<h3>Why we built BillingBird this way</h3>')"
accessibility_line="$(line_number '<h3>Accessibility</h3>')"
technical_line="$(line_number '<h3>Technical specifications</h3>')"
side_card_line="$(line_number '<aside class="side-card">')"

if ! (( ownership_line < built_ownership_line &&
        built_ownership_line < built_business_line &&
        why_line < accessibility_line &&
        accessibility_line < technical_line &&
        technical_line < side_card_line )); then
  echo 'BillingBird ownership, feature, rationale, accessibility, and technical sections are out of order.' >&2
  exit 1
fi

reject '<h2 id="overview">Overview</h2>' 'Overview must not remain the primary heading'
reject '<h3>What it does</h3>' 'Feature-first heading must not remain'
reject '<h3>How your data is stored</h3>' 'Technical storage heading must not remain'
reject '<h3>Platform</h3>' 'Platform details should not remain a primary marketing section'

echo "BillingBird ownership page checks passed."

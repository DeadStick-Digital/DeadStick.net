#!/usr/bin/env bash
set -euo pipefail

# Plain grep (not git grep) so the gate also validates files that are not yet
# committed; once committed the behavior is identical.
require() {
  local pattern="$1"
  local file="$2"
  local message="$3"

  if ! grep -qF "$pattern" "$file"; then
    printf 'Missing expected DeadStick Utilities app-page state: %s\n' "$message" >&2
    exit 1
  fi
}

reject() {
  local pattern="$1"
  local file="$2"
  local message="$3"

  if grep -qF "$pattern" "$file"; then
    printf 'Forbidden DeadStick Utilities app-page copy: %s\n' "$message" >&2
    exit 1
  fi
}

PAGE="apps/deadstick-utilities.html"

[ -f "$PAGE" ] || { echo "Missing $PAGE" >&2; exit 1; }

require 'security-measures is-deadstick-utilities' \
  "$PAGE" \
  'Recovery panel should use the DeadStick Utilities security-measures variant'

require 'Coming soon to the Mac App Store' "$PAGE" 'Page should state the Mac App Store release status'
require 'macOS 15 or later' "$PAGE" 'Page should state the minimum macOS version'
require 'Moving files to Recovery normally does not free disk space' "$PAGE" 'Page should state the Recovery disk-space limit'
require 'cannot be restored by DeadStick' "$PAGE" 'Page should state that permanent deletion is final'
require 'does not delete' "$PAGE" 'Page should say held files are not deleted on their own'
require '7-day free trial' "$PAGE" 'Page should disclose the eligible free trial'
require 'US reference price; the App Store shows your local price' "$PAGE" 'Page should state the annual US reference price'
require '$9.99/year' "$PAGE" 'Page should state the annual price'
require 'renews automatically' "$PAGE" 'Page should disclose auto-renewal'
require 'stay available without a' "$PAGE" 'Page should state Recovery stays available without a subscription'
require 'no background agent' "$PAGE" 'Page should state there is no background agent'
for area in 'Smart Scan' 'Full System Scan' 'Custom Scan' 'Clean Up' 'Large Files' 'Duplicates' 'Storage' 'Apps' 'Mac Status' 'Recovery'; do
  require "$area" "$PAGE" "Page should name the shipped sidebar item or scan mode: $area"
done
require 'Scanning only reads' "$PAGE" 'Page should state that scanning only reads'
require 'choose which copy to keep' "$PAGE" 'Page should state that duplicates need a keep choice'
require "need an active subscription or Apple's free trial" "$PAGE" 'Page should state what needs a subscription'
require 'Privacy, Settings and Help stay available without a' "$PAGE" 'Page should state what stays free'
require '../deadstick-utilities/privacy/' "$PAGE" 'Page should link the app privacy policy URL'
require '../deadstick-utilities/support/' "$PAGE" 'Page should link the app support URL'
require '../deadstick-utilities/terms/' "$PAGE" 'Page should link the app terms URL'

for blocked in iPhone iPad iOS NIAP FIPS VPAT 508 MDM notarized government quarantine \
  'every connection' 'Pro ' 'SBOM' 'certified' 'FedRAMP' '100% secure' 'secure erase' \
  'undo for every file' 'file recovery' 'your Mac is unsafe' 'App Store Download' \
  'Diagnostics' 'six areas' 'Six areas' '>Overview<'; do
  reject "$blocked" "$PAGE" "Page must not say: $blocked"
done

UTIL_CARD="$(sed -n '/<!-- ==== DeadStick Utilities ==== -->/,/<\/article>/p' index.html)"
for blocked in iPhone iPad iOS NIAP FIPS SBOM government quarantine diagnostics Diagnostics; do
  if printf '%s' "$UTIL_CARD" | grep -qF "$blocked"; then
    printf 'Forbidden DeadStick Utilities homepage card copy: %s\n' "$blocked" >&2
    exit 1
  fi
done

require '<article class="app-card is-deadstick-utilities is-coming-soon" data-status="Coming soon">' \
  index.html \
  'Homepage should show the DeadStick Utilities coming-soon card'

require '<a class="app-icon app-icon-link" href="apps/deadstick-utilities.html" aria-label="Open DeadStick Utilities app page">' \
  index.html \
  'DeadStick Utilities icon should link to its app page'

require 'Five apps. One philosophy.' \
  index.html \
  'Homepage apps heading should count five apps'

require '.app-card.is-deadstick-utilities { --card-accent: var(--deadstick-utilities); --card-accent-soft: var(--deadstick-utilities-soft); }' \
  styles.css \
  'Styles should map the DeadStick Utilities card accent'

reject '.app-card.is-deadstick-utilities { grid-column' \
  styles.css \
  'DeadStick Utilities card must share the same footprint as the other app cards'

echo "DeadStick Utilities app page checks passed."

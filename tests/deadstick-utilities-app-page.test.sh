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

require 'designed to meet or exceed applicable government-grade software assurance practices' \
  "$PAGE" \
  'Assurance claim must use the sanctioned designed-to-meet-or-exceed phrasing'

require 'No agency approval, certification, or formal validation' \
  "$PAGE" \
  'Assurance panel must disclaim certification'

require 'No government approval, NIAP certification, Common Criteria' \
  "$PAGE" \
  'Footer legal note must disclaim certification and validation'

require 'security-measures is-deadstick-utilities' \
  "$PAGE" \
  'Assurance panel should use the DeadStick Utilities security-measures variant'

require 'Protection Profile for Application Software' "$PAGE" 'NIAP item should name the actual Protection Profile'
require 'FIPS 140-3' "$PAGE" 'FIPS item should name the standard by number'
require 'National Information Assurance Partnership' "$PAGE" 'NIAP should be spelled out for readers'
require 'NIST SP 800-218' "$PAGE" 'Assurance list should name NIST SSDF by number'
require 'software bill of materials' "$PAGE" 'Assurance list should name the SBOM release gate'
require 'VPAT/ACR' "$PAGE" 'Assurance list should name the accessibility evidence track'
require 'No custom cryptography' "$PAGE" 'Assurance list should state the crypto posture'
require '../deadstick-utilities/privacy/' "$PAGE" 'Page should link the app privacy policy URL'
require '../deadstick-utilities/support/' "$PAGE" 'Page should link the app support URL'
require 'do not let third-party apps clean system caches' \
  "$PAGE" \
  'Page should state honest iOS/iPadOS platform limits'

reject 'certified' "$PAGE" 'Page must not claim certification'
reject 'FedRAMP' "$PAGE" 'Page must not invoke FedRAMP'
reject '100% secure' "$PAGE" 'Page must not claim 100% secure'
reject 'your Mac is unsafe' "$PAGE" 'Page must not use scareware urgency copy'

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

require '.apps-grid .app-card.is-deadstick-utilities { grid-column: 1 / -1; }' \
  styles.css \
  'DeadStick Utilities card should span the full grid row'

echo "DeadStick Utilities app page checks passed."

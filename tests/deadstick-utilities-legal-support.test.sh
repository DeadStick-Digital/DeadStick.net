#!/usr/bin/env bash
set -euo pipefail

require() {
  local pattern="$1"
  local file="$2"
  local message="$3"

  if ! grep -q "$pattern" "$file"; then
    printf 'Missing expected DeadStick Utilities website copy: %s\n' "$message" >&2
    exit 1
  fi
}

reject() {
  local pattern="$1"
  local file="$2"
  local message="$3"

  if grep -q "$pattern" "$file"; then
    printf 'Blocked DeadStick Utilities website copy found: %s\n' "$message" >&2
    exit 1
  fi
}

pages=(
  deadstick-utilities/index.html
  deadstick-utilities/privacy/index.html
  deadstick-utilities/terms/index.html
  deadstick-utilities/support/index.html
)

for page in "${pages[@]}"; do
  test -f "$page"
  require 'DeadStick Utilities' "$page" "$page should identify the product"
  require 'styles.css?v=20260625-deadstick-utilities' "$page" "$page should use the DeadStick Utilities stylesheet version"
  require 'du-console' "$page" "$page should use the Soft Spectrum console treatment"
  reject '\[TBD\]' "$page" "$page should not publish bracket placeholders"
  reject '100% secure' "$page" "$page should avoid impossible security claims"
  reject 'government approved' "$page" "$page should avoid government approval claims"
done

require '<title>DeadStick Utilities — DeadStick Digital LLC</title>' \
  deadstick-utilities/index.html \
  'product overview title should be present'

require 'Coming soon to the Mac App Store' \
  deadstick-utilities/index.html \
  'product overview should state the Mac App Store release status'

require '7-day free trial for eligible customers, then $9.99/year' \
  deadstick-utilities/index.html \
  'product overview should state the eligible trial and annual price'

require 'https://www.deadstick.net/deadstick-utilities/support' \
  deadstick-utilities/privacy/index.html \
  'privacy page should expose the Support URL'

require 'File contents, file names and scan results stay on your Mac' \
  deadstick-utilities/privacy/index.html \
  'privacy page should state the on-Mac data boundary'

require 'Apple processes subscription purchases' \
  deadstick-utilities/privacy/index.html \
  'privacy page should name Apple as the subscription processor'

require '<strong>$9.99/year</strong>' \
  deadstick-utilities/terms/index.html \
  'terms page should include the annual price'

require 'renews automatically unless canceled at least 24 hours before the end of the current period' \
  deadstick-utilities/terms/index.html \
  'terms page should include renewal disclosure'

require 'manage or cancel it in your Apple account settings' \
  deadstick-utilities/terms/index.html \
  'terms page should include cancellation guidance'

require 'Licensed Application End User License Agreement' \
  deadstick-utilities/terms/index.html \
  'terms page should reference the Apple standard EULA'

require 'free any particular amount of disk space' \
  deadstick-utilities/terms/index.html \
  'terms page should disclaim a particular amount of disk space'

require 'https://www.deadstick.net/deadstick-utilities/privacy' \
  deadstick-utilities/terms/index.html \
  'terms page should link the Privacy URL'

require 'Support contact: <a href="../../index.html#contact">DeadStick Digital message form</a>' \
  deadstick-utilities/support/index.html \
  'support page should use the existing approved site contact path instead of a placeholder'

require 'Restore Purchases' \
  deadstick-utilities/support/index.html \
  'support page should explain Restore Purchases'

require 'Restore Files From Recovery' \
  deadstick-utilities/support/index.html \
  'support page should explain restoring from Recovery'

for page in "${pages[@]}"; do
  require 'Last updated: October 2, 2026\|Coming soon to the Mac App Store' "$page" "$page should carry the current date or release status"
  for blocked in iPhone iPad iOS NIAP FIPS VPAT 508 MDM notarized government quarantine \
    'every connection' 'Pro ' 'pre-release' 'Pre-release' 'Free MVP' 'file recovery' 'secure erase'; do
    reject "$blocked" "$page" "$page must not say: $blocked"
  done
done

require '.du-console' \
  styles.css \
  'Soft Spectrum console CSS should exist'

require '.du-flow' \
  styles.css \
  'Soft Spectrum flow CSS should exist'

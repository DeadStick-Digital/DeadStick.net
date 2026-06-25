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

require 'Planned annual unlocks at $9.99/year' \
  deadstick-utilities/index.html \
  'product overview should name the planned Pro annual price'

require 'https://www.deadstick.net/deadstick-utilities/support' \
  deadstick-utilities/privacy/index.html \
  'privacy page should expose the candidate Support URL'

require 'not designed to upload file names, file paths, photo contents, contact contents' \
  deadstick-utilities/privacy/index.html \
  'privacy page should preserve local-first no-default-upload posture'

require 'DeadStick Utilities cannot clean protected iPhone or iPad system storage' \
  deadstick-utilities/privacy/index.html \
  'privacy page should explain iOS/iPadOS platform limits'

require 'annual subscription at <strong>$9.99/year</strong>' \
  deadstick-utilities/terms/index.html \
  'terms page should include the planned Pro annual price'

require 'It renews automatically until canceled' \
  deadstick-utilities/terms/index.html \
  'terms page should include renewal disclosure'

require 'Users manage or cancel App Store subscriptions in their Apple account settings' \
  deadstick-utilities/terms/index.html \
  'terms page should include cancellation guidance'

require 'https://www.deadstick.net/deadstick-utilities/privacy' \
  deadstick-utilities/terms/index.html \
  'terms page should link the candidate Privacy URL'

require 'Support contact: <a href="../../index.html#contact">DeadStick Digital message form</a>' \
  deadstick-utilities/support/index.html \
  'support page should use the existing approved site contact path instead of a placeholder'

require 'DeadStick Utilities does not provide iPhone/iPad protected system cleanup' \
  deadstick-utilities/support/index.html \
  'support page should preserve platform-honest support copy'

require '.du-console' \
  styles.css \
  'Soft Spectrum console CSS should exist'

require '.du-flow' \
  styles.css \
  'Soft Spectrum flow CSS should exist'

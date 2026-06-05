#!/usr/bin/env bash
set -euo pipefail

require() {
  local pattern="$1"
  local file="$2"
  local message="$3"

  if ! git grep -q "$pattern" -- "$file"; then
    printf 'Missing expected BillingBird privacy language: %s\n' "$message" >&2
    exit 1
  fi
}

reject() {
  local pattern="$1"
  local file="$2"
  local message="$3"

  if git grep -q "$pattern" -- "$file"; then
    printf 'Outdated BillingBird privacy language remains: %s\n' "$message" >&2
    exit 1
  fi
}

require 'Last updated: June 5, 2026' \
  privacy.html \
  'Privacy policy should show the latest app-copy update date'

require "For BillingBird's iOS App Store release, DeadStick Digital does not collect data" \
  privacy.html \
  'iOS App Store release should explicitly align with Data Not Collected'

require 'from the app. Client records, invoices, receipts, attachments, reports, and settings remain' \
  privacy.html \
  'Policy should describe the data that remains under user control'

require 'DeadStick Digital does not receive, read, or store BillingBird app data.' \
  privacy.html \
  'Policy should state DeadStick cannot access BillingBird app data'

require 'Google Drive sync may be available on some platforms or future releases.' \
  privacy.html \
  'Google Drive availability should be qualified for the current iOS build'

require 'Store release uses local storage and optional iCloud sync only.' \
  privacy.html \
  'Current iOS sync options should be explicit'

reject 'You may optionally enable sync via <strong>Apple iCloud</strong> or' \
  privacy.html \
  'Old wording made Google Drive sound available in the current iOS release'

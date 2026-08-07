#!/usr/bin/env bash
set -euo pipefail

require() {
  local pattern="$1"
  local file="$2"
  local message="$3"

  if ! grep -qF "$pattern" "$file"; then
    printf 'Missing expected BillingBird privacy language: %s\n' "$message" >&2
    exit 1
  fi
}

reject() {
  local pattern="$1"
  local file="$2"
  local message="$3"

  if grep -qF "$pattern" "$file"; then
    printf 'Outdated BillingBird privacy language remains: %s\n' "$message" >&2
    exit 1
  fi
}

require 'Last updated: July 19, 2026' privacy.html \
  'Privacy policy should show the iPhone-first copy update date'
require 'available now on iPhone; iPadOS, macOS, Android, and Windows support is planned' privacy.html \
  'Scope should identify iPhone launch and planned platforms'
require 'private local app storage on your iPhone' privacy.html \
  'Policy should describe the current iPhone storage boundary'
require 'DeadStick Digital does not collect,' privacy.html \
  'Policy should state that DeadStick does not collect bookkeeping records'
require 'optional private iCloud backup' privacy.html \
  'Policy should qualify optional iCloud backup'
require 'RevenueCat may process the' privacy.html \
  'Policy should identify the separate entitlement service'
require '<a href="https://www.revenuecat.com/privacy">RevenueCat</a>' privacy.html \
  'Service-provider list should disclose RevenueCat and link its policy'
require 'automatically generated app-user identifier' privacy.html \
  'Policy should identify the RevenueCat customer boundary'
require 'device/platform information, and entitlement status' privacy.html \
  'General purchase summary should match the RevenueCat processor disclosure'
require 'DeadStick does not receive your credit card, billing address, or real name' privacy.html \
  'Purchase summary should retain the payment-data boundary'
require 'direct RevenueCat' privacy.html \
  'Policy should explain provider-held record deletion handling'
require 'it does not' privacy.html \
  'Policy should separate entitlements from bookkeeping records'
require 'receive your BillingBird bookkeeping records.' privacy.html \
  'Policy should state the RevenueCat bookkeeping boundary'
require 'those platforms are not yet shipping' privacy.html \
  'Policy should not imply future-platform data handling is already implemented'

reject 'private local app storage on your iPhone, iPad, or Mac' privacy.html \
  'Retired multi-Apple current storage claim should be removed'
reject 'for iPhone, iPad, and Mac' privacy.html \
  'Retired multi-Apple scope line should be removed'
reject 'Built for iPhone, iPad &amp; Mac' privacy.html \
  'Multi-Apple marketing claim must not appear in privacy'
reject 'Google Drive sync may be available on some platforms or future releases.' privacy.html \
  'BillingBird privacy copy should not advertise future Google Drive behavior'

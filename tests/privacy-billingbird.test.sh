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

require 'Last updated: July 13, 2026' privacy.html \
  'Privacy policy should show the Apple-platform copy update date'
require '<strong>BillingBird</strong> — a private invoicing and receipt app for iPhone, iPad, and Mac' privacy.html \
  'Scope should identify the supported Apple devices'
require 'private local app storage on your iPhone, iPad, or Mac' privacy.html \
  'Policy should describe the local storage boundary'
require 'DeadStick Digital does not collect,' privacy.html \
  'Policy should state that DeadStick does not collect bookkeeping records'
require 'optional private iCloud backup and handoff' privacy.html \
  'Policy should qualify optional iCloud continuity'
require 'single-active-device handoff' privacy.html \
  'Policy should reject a realtime multi-device interpretation'
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

reject "For BillingBird's iOS App Store release" privacy.html \
  'iPhone-only release language should not exclude iPad and Mac'
reject 'Google Drive sync may be available on some platforms or future releases.' privacy.html \
  'BillingBird privacy copy should no longer advertise future Google Drive behavior'

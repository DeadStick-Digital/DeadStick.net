#!/usr/bin/env bash
set -euo pipefail

PAGE="apps/billingbird.html"

[ -f "$PAGE" ] || { echo "Missing $PAGE" >&2; exit 1; }

require() {
  local pattern="$1"
  local message="$2"

  if ! grep -qF "$pattern" "$PAGE"; then
    printf 'Missing expected BillingBird page state: %s\n' "$message" >&2
    exit 1
  fi
}

reject() {
  local pattern="$1"
  local message="$2"

  if grep -qF "$pattern" "$PAGE"; then
    printf 'Outdated or unsupported BillingBird copy remains: %s\n' "$message" >&2
    exit 1
  fi
}

line_number() {
  grep -nF "$1" "$PAGE" | head -n 1 | cut -d: -f1
}

require '<link rel="canonical" href="https://www.deadstick.net/apps/billingbird.html">' 'canonical URL should identify the public product page'
require '<link rel="stylesheet" href="../styles.css?v=20260713-billingbird-apple">' 'product page should cache-bust its scoped BillingBird styling'
require '<meta property="og:title" content="BillingBird — Professional billing. Your books stay yours.">' 'Open Graph title should carry the new positioning'
require '"@type": "SoftwareApplication"' 'structured data should identify a software application'
require '"operatingSystem": "iOS 17 or later; iPadOS 17 or later; macOS 14 or later"' 'structured data should name the supported Apple platforms'
require 'BillingBird · Private invoicing for Apple devices' 'hero eyebrow should identify the Apple-platform focus'
require 'Professional billing. Your books stay yours.' 'hero should lead with professional quality and ownership'
require 'href="#why-billingbird">Why BillingBird is different' 'primary hero action should reach the value section'
require 'href="../privacy.html#apps">Privacy details</a>' 'privacy should remain the secondary hero action'
require '<div class="detail-body" id="overview">' 'the existing overview compatibility anchor should remain'
require '<h2 id="why-billingbird">Why BillingBird is different</h2>' 'the new value-section anchor should be available'
require '<h3>Private by architecture</h3>' 'privacy should be one of the three pillars'
require '<h3>Professional where it matters</h3>' 'quality should be one of the three pillars'
require '<h3>Built for iPhone, iPad &amp; Mac</h3>' 'Apple continuity should be one of the three pillars'
require '<section class="billingbird-data-path" aria-label="How BillingBird handles your records">' 'data path should expose an accessible semantic label'
require '<strong>Local device storage.</strong>' 'data path should begin on the device'
require '<strong>Optional private iCloud backup and handoff.</strong>' 'data path should explain optional private iCloud'
require '<strong>No readable DeadStick bookkeeping database.</strong>' 'data path should precisely state the server boundary'
require 'single-active-device' 'iCloud should be described as a guarded handoff'
require 'not real-time collaboration or simultaneous editing' 'iCloud should not imply multiuser realtime sync'
require 'RevenueCat may provide subscription entitlement services' 'subscription infrastructure should be qualified separately from bookkeeping records'
require 'manual, partial, and completed payments' 'professional outcomes should include manual payment tracking'
require 'recurring drafts' 'professional outcomes should include recurring drafts'
require 'On iPhone and iPad, scan receipts on-device' 'mobile receipt capture should be explicit'
require 'On Mac, bring in receipt images and PDFs through Files-based import' 'Mac receipt import should be explicit'
require 'VoiceOver and Dynamic Type across supported Apple devices' 'cross-platform accessibility capabilities should stay within verified evidence'
require 'keyboard shortcuts on Mac' 'Mac keyboard behavior should be described precisely'
require 'seven color themes' 'theme count should match the current BillingBird appearance settings'
require 'iOS 17 or later, iPadOS 17 or later, and macOS 14 or later' 'technical specifications should name exact platform floors'
require 'through Mac Catalyst' 'Mac implementation should be accurate'
require '<dt>Account</dt>      <dd>None required</dd>' 'no-account posture should remain visible'
require 'href="../support.html">Support</a>' 'support should remain available in the footer'

why_line="$(line_number '<h2 id="why-billingbird">')"
pillars_line="$(line_number '<div class="billingbird-pillars"')"
data_line="$(line_number '<section class="billingbird-data-path"')"
quality_line="$(line_number '<h3>Professional work, from estimate to archive</h3>')"
technical_line="$(line_number '<h3>Technical specifications</h3>')"
side_card_line="$(line_number '<aside class="side-card">')"

if ! (( why_line < pillars_line &&
        pillars_line < data_line &&
        data_line < quality_line &&
        quality_line < technical_line &&
        technical_line < side_card_line )); then
  echo 'BillingBird value, data, quality, technical, and side-card sections are out of order.' >&2
  exit 1
fi

reject 'Most invoicing apps' 'unsupported competitor generalizations must be removed'
reject 'no lock-in' 'absolute portability language must be removed'
reject 'You stay in control. Always.' 'absolute control language must be removed'
reject 'Android' 'Android should not appear on the current BillingBird page'
reject 'TalkBack' 'TalkBack should not appear on the current BillingBird page'
reject 'Google Drive' 'Google Drive should not appear on the current BillingBird page'
reject 'React Native 0.76' 'stale framework versions should not remain in marketing copy'
reject 'Expo SDK 52' 'stale framework versions should not remain in marketing copy'
reject 'six themes' 'retired theme count should not remain'
reject 'keyboard navigation, and high-contrast' 'accessibility copy should not exceed verified platform evidence'
reject '"offers"' 'structured data must not claim availability or pricing'
reject '"price"' 'structured data must not claim availability or pricing'

echo "BillingBird ownership and positioning page checks passed."

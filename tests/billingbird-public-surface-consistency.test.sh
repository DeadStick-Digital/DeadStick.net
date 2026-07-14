#!/usr/bin/env bash
set -euo pipefail

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

extract_between() {
  local file="$1"
  local start="$2"
  local end="$3"
  local output="$4"

  awk -v start="$start" -v end="$end" '
    index($0, start) { copying = 1 }
    copying && index($0, end) { exit }
    copying { print }
  ' "$file" > "$output"
}

extract_between index.html '<!-- ==== BillingBird ==== -->' '<!-- ==== CarrierPigeonVPN ==== -->' "$tmp_dir/homepage"
cp apps/billingbird.html "$tmp_dir/product"
extract_between privacy.html '<h3>10.1 BillingBird</h3>' '<h3>10.2 CarrierPigeonVPN</h3>' "$tmp_dir/privacy"
grep 'BillingBird</a> —' support.html > "$tmp_dir/support"
extract_between deletion.html '<h2 id="billingbird">BillingBird</h2>' '<h2 id="carrierpigeonvpn">' "$tmp_dir/deletion"
extract_between terms.html '<h3 id="apps-billingbird">' '<h3 id="apps-carrierpigeonvpn">' "$tmp_dir/terms"
extract_between acknowledgements.html '<h2 id="billingbird">' '<h2 id="carrierpigeonvpn">' "$tmp_dir/acknowledgements"

cat "$tmp_dir"/* > "$tmp_dir/all-billingbird"

if grep -Eqi 'Android|TalkBack|Google Drive|React Native 0\.76|Expo( SDK)? 52' "$tmp_dir/all-billingbird"; then
  echo 'A BillingBird-specific public surface still contains Android, TalkBack, Google Drive, or stale framework claims.' >&2
  grep -Eni 'Android|TalkBack|Google Drive|React Native 0\.76|Expo( SDK)? 52' "$tmp_dir/all-billingbird" >&2
  exit 1
fi

require_in_scope() {
  local pattern="$1"
  local file="$2"
  local message="$3"
  if ! grep -qF "$pattern" "$file"; then
    printf 'Missing BillingBird public-surface state: %s\n' "$message" >&2
    exit 1
  fi
}

require_in_scope 'Built for iPhone, iPad &amp; Mac' "$tmp_dir/homepage" 'homepage should name the supported devices'
require_in_scope 'Private by architecture' "$tmp_dir/product" 'product page should lead with the privacy pillar'
require_in_scope 'private local app storage on your iPhone, iPad, or Mac' "$tmp_dir/privacy" 'privacy should match the Apple platform scope'
require_in_scope 'private invoicing &amp; receipts for iPhone, iPad, and Mac' "$tmp_dir/support" 'support should match the Apple platform scope'
require_in_scope '<strong>Private iCloud copy.</strong>' "$tmp_dir/deletion" 'deletion should cover the private iCloud copy'
require_in_scope '<strong>BillingBird Pro subscription record.</strong>' "$tmp_dir/deletion" 'deletion should cover provider-held subscription records'
require_in_scope 'single-active-device handoff' "$tmp_dir/terms" 'terms should qualify iCloud handoff behavior'
require_in_scope 'React Native</a></strong> 0.85.3' "$tmp_dir/acknowledgements" 'acknowledgements should name the current React Native version'
require_in_scope 'Expo</a></strong> SDK 56' "$tmp_dir/acknowledgements" 'acknowledgements should name the current Expo version'
require_in_scope '<strong>Apple CloudKit and iCloud</strong>' "$tmp_dir/acknowledgements" 'acknowledgements should name Apple private-cloud services'
require_in_scope '<strong>VisionKit</strong>' "$tmp_dir/acknowledgements" 'acknowledgements should name VisionKit'

grep -qF '<a href="https://www.revenuecat.com/privacy">RevenueCat</a>' privacy.html || {
  echo 'Privacy service-provider disclosures do not include RevenueCat.' >&2
  exit 1
}
grep -qF 'direct RevenueCat' privacy.html || {
  echo 'Privacy retention copy does not explain RevenueCat deletion handling.' >&2
  exit 1
}

# These technologies still accurately belong to other DeadStick products and global policies.
grep -qF 'CarrierPigeonVPN</a> — paired-phone networking for macOS, Windows, tvOS, iOS, and Android' support.html || {
  echo 'CarrierPigeonVPN Android support was removed unintentionally.' >&2
  exit 1
}
grep -qF 'through iCloud or Google Drive' terms.html || {
  echo 'Other products\x27 Google Drive language was removed unintentionally.' >&2
  exit 1
}

echo 'BillingBird public-surface consistency checks passed.'

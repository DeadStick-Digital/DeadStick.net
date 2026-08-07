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

cp apps/billingbird.html "$tmp_dir/product"
extract_between index.html '<!-- ==== BillingBird ==== -->' '<!-- ==== CarrierPigeonVPN ==== -->' "$tmp_dir/homepage"
extract_between privacy.html '<h3>10.1 BillingBird</h3>' '<h3>10.2 CarrierPigeonVPN</h3>' "$tmp_dir/privacy"
grep 'BillingBird</a> —' support.html > "$tmp_dir/support"
extract_between deletion.html '<h2 id="billingbird">BillingBird</h2>' '<h2 id="carrierpigeonvpn">' "$tmp_dir/deletion"
extract_between terms.html '<h3 id="apps-billingbird">' '<h3 id="apps-carrierpigeonvpn">' "$tmp_dir/terms"
extract_between acknowledgements.html '<h2 id="billingbird">' '<h2 id="carrierpigeonvpn">' "$tmp_dir/acknowledgements"

cat "$tmp_dir"/* > "$tmp_dir/all-billingbird"

if grep -Eqi 'TalkBack|Google Drive|React Native 0\.76|Expo( SDK)? 52' "$tmp_dir/all-billingbird"; then
  echo 'A BillingBird-specific public surface still contains TalkBack, Google Drive, or stale framework claims.' >&2
  grep -Eni 'TalkBack|Google Drive|React Native 0\.76|Expo( SDK)? 52' "$tmp_dir/all-billingbird" >&2
  exit 1
fi

if grep -Eqi 'for Apple devices|Built for iPhone, iPad &amp; Mac|Built for iPhone, iPad & Mac' "$tmp_dir/all-billingbird"; then
  echo 'A BillingBird-specific public surface still claims multi-Apple current shipping support.' >&2
  grep -Eni 'for Apple devices|Built for iPhone, iPad' "$tmp_dir/all-billingbird" >&2
  exit 1
fi

if grep -Eq 'iOS 17 or later; iPadOS 17 or later; macOS 14 or later|iPadOS 17 or later|macOS 14 or later' "$tmp_dir/product"; then
  echo 'BillingBird product page still advertises planned Apple OS floors as current metadata.' >&2
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

require_in_scope '"operatingSystem": "iOS 17 or later"' "$tmp_dir/product" 'product JSON-LD should be iPhone-current only'
require_in_scope 'The launch version lets you record manual payments. Online payment collection is planned for a later release.' "$tmp_dir/product" 'product page should clarify manual payments'
require_in_scope 'Available now on iPhone' "$tmp_dir/homepage" 'homepage card should state iPhone availability'
require_in_scope 'iPadOS, macOS, Android, and Windows support is planned' "$tmp_dir/homepage" 'homepage card should mention planned platforms without claiming them current'
require_in_scope 'private local app storage on your iPhone' "$tmp_dir/privacy" 'privacy should describe current iPhone storage'
require_in_scope 'iPadOS, macOS, Android, and Windows support' "$tmp_dir/privacy" 'privacy should mention planned platforms without claiming them current'
require_in_scope 'private invoicing &amp; receipts, available now on iPhone' "$tmp_dir/support" 'support should match iPhone availability scope'
require_in_scope '<strong>Private iCloud copy.</strong>' "$tmp_dir/deletion" 'deletion should cover the private iCloud copy'
require_in_scope '<strong>BillingBird Pro subscription record.</strong>' "$tmp_dir/deletion" 'deletion should cover provider-held subscription records'
require_in_scope '<strong>iPhone.</strong>' "$tmp_dir/deletion" 'deletion should describe the current iPhone path'
require_in_scope 'available first on iPhone' "$tmp_dir/terms" 'terms should state iPhone-first availability'
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

#!/usr/bin/env bash
# CarrierPigeonVPN public claims must match what the shipping iPhone and Mac
# apps do (App Review Guideline 2.3.1 covers marketing "within or outside of
# the App Store"), and the subscription terms must be stated (3.1.2).
set -euo pipefail

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

extract_between() {
  awk -v start="$2" -v end="$3" '
    index($0, start) { copying = 1 }
    copying && index($0, end) { exit }
    copying { print }
  ' "$1" > "$4"
}

cp apps/carrierpigeonvpn.html "$tmp_dir/product"
extract_between index.html '<!-- ==== CarrierPigeonVPN ==== -->' '<!-- ==== Document Vault ==== -->' "$tmp_dir/homepage"
extract_between privacy.html '<h3>10.2 CarrierPigeonVPN</h3>' '<h3>10.3 ' "$tmp_dir/privacy"
grep 'CarrierPigeonVPN</a> —' support.html > "$tmp_dir/support"
extract_between deletion.html '<h2 id="carrierpigeonvpn">' '<h2 id="holos-document-vault">' "$tmp_dir/deletion"
extract_between terms.html '<h3 id="apps-carrierpigeonvpn">' '<h3 id="apps-holos-document-vault">' "$tmp_dir/terms"
cat "$tmp_dir"/* > "$tmp_dir/all"
# Sentences wrap across lines in the HTML; compare with whitespace collapsed.
for f in "$tmp_dir"/*; do tr -s ' \n\t' ' ' < "$f" > "$f.flat"; mv "$f.flat" "$f"; done

fail() { echo "$1" >&2; grep -Eni "$2" "$tmp_dir/all" >&2 || true; exit 1; }

# Claims the product cannot back.
pattern='up to (5|five)|five receiving|screen-off|\(Wi-Fi or USB\)|via Wi-Fi or USB|lightning|rock-solid|zero-configuration|incredibly low latency'
grep -Eqi "$pattern" "$tmp_dir/all" && fail 'A CarrierPigeonVPN public surface makes a claim the app cannot back.' "$pattern"

# Stale platform minimums and platforms presented as shipping.
pattern='iOS 17|macOS 14|tvOS 17|Android 12|Windows 11|Mac, PC, or Apple TV|Companions for macOS, Windows, and tvOS|Mobile app for iOS and Android'
grep -Eqi "$pattern" "$tmp_dir/all" && fail 'A CarrierPigeonVPN public surface lists stale platforms or minimums.' "$pattern"

# Old trial length.
pattern='14[- ]day|two[- ]week|2[- ]week'
grep -Eqi "$pattern" "$tmp_dir/all" && fail 'A CarrierPigeonVPN public surface still states the old trial length.' "$pattern"

# Required subscription terms on the product page and in the terms.
for required in '7-day free trial' '\$9\.99 per year' 'at least 24 hours before' 'Apple Account settings'; do
  grep -Eq "$required" "$tmp_dir/product" || { echo "Product page is missing: $required" >&2; exit 1; }
done
grep -q 'id="cpvpn-subscription"' terms.html || { echo 'terms.html is missing the CarrierPigeonVPN subscription section.' >&2; exit 1; }
grep -Eq 'iOS 26 or later' "$tmp_dir/product" && grep -Eq 'macOS 26 or later' "$tmp_dir/product" \
  || { echo 'Product page must state iOS 26 and macOS 26 minimums.' >&2; exit 1; }

# WireGuard's trademark policy bars using the mark to advertise or to suggest a
# relationship without permission. The marketing surfaces say "VPN tunnel";
# the acknowledgements page carries the attribution and trademark notice.
cat "$tmp_dir/product" "$tmp_dir/homepage" > "$tmp_dir/marketing"
grep -qi 'wireguard' "$tmp_dir/marketing" && fail 'A CarrierPigeonVPN marketing surface uses the WireGuard trademark.' 'wireguard'

# Guideline 5.4 commitment stays in the privacy policy and on the product page.
grep -q 'does not sell, use, or' "$tmp_dir/privacy" || { echo 'privacy.html 10.2 lost the 5.4 commitment.' >&2; exit 1; }
grep -q 'does not sell, use, or disclose' "$tmp_dir/product" || { echo 'Product page lost the 5.4 commitment.' >&2; exit 1; }
# Audit 2026-09-30: the commitment must not read as denying the RevenueCat and
# DNS disclosures right before it. RevenueCat works on our behalf; DNS lookups
# are the user's own traffic.
grep -q 'RevenueCat processes your purchase on our behalf' "$tmp_dir/privacy" \
  && grep -q 'as your own traffic' "$tmp_dir/privacy" \
  || { echo 'privacy.html 10.2 must square the 5.4 commitment with RevenueCat and DNS.' >&2; exit 1; }
grep -q 'RevenueCat, which works on our behalf' "$tmp_dir/product" \
  || { echo 'Product page must say RevenueCat works on our behalf.' >&2; exit 1; }

echo 'CarrierPigeonVPN public claims are consistent.'

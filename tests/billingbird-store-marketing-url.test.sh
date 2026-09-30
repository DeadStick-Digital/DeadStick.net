#!/usr/bin/env bash
set -euo pipefail

# The live BillingBird App Store listing (1.0.0 through 1.0.2) uses
# https://www.deadstick.net/billingbird.html as its marketing URL. Keep that
# address forwarding to the product page until a listing update changes it.
PAGE="billingbird.html"

[ -f "$PAGE" ] || { echo "Missing $PAGE, the App Store marketing URL for BillingBird" >&2; exit 1; }

require() {
  local pattern="$1"
  local message="$2"

  if ! grep -qF "$pattern" "$PAGE"; then
    printf 'Missing expected BillingBird forwarding state: %s\n' "$message" >&2
    exit 1
  fi
}

require '<meta http-equiv="refresh" content="0; url=apps/billingbird.html">' 'old address should forward to the product page'
require '<link rel="canonical" href="https://www.deadstick.net/apps/billingbird.html">' 'search engines should credit the product page'
require '<meta name="robots" content="noindex">' 'the forwarding page itself should stay out of search results'
require '<a href="apps/billingbird.html">' 'visitors whose browser ignores the refresh still get a link'

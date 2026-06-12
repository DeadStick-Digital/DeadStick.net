#!/usr/bin/env bash
set -euo pipefail

require() {
  local pattern="$1"
  local file="$2"
  local message="$3"

  if ! git grep -q "$pattern" -- "$file"; then
    printf 'Missing expected CryptScan product name: %s\n' "$message" >&2
    exit 1
  fi
}

require '<div class="app-tag">Secure Document Scanner</div>' \
  index.html \
  'Homepage card should use Secure Document Scanner as the category label'

require '<h3>CryptScan</h3>' \
  index.html \
  'Homepage card should use the short CryptScan product name'

require '<li><a href="apps/cryptscan.html">CryptScan</a></li>' \
  index.html \
  'Homepage footer app list should use the short CryptScan product name'

require '<title>CryptScan — DeadStick Digital LLC</title>' \
  apps/cryptscan.html \
  'CryptScan detail page title should use the short product name'

require 'Coming soon · Secure Document Scanner' \
  apps/cryptscan.html \
  'CryptScan detail page eyebrow should use Secure Document Scanner'

require '<h1>CryptScan</h1>' \
  apps/cryptscan.html \
  'CryptScan detail page hero should use the short product name'

require '<a href="apps/cryptscan.html">CryptScan</a>' \
  support.html \
  'Support page app list should use the short product name'

require '<strong>CryptScan</strong>' \
  privacy.html \
  'Privacy app list should use the short product name'

require '<h2 id="cryptscan">CryptScan</h2>' \
  deletion.html \
  'Deletion page heading should use the short product name'

require '<h3 id="apps-cryptscan">14.3 CryptScan</h3>' \
  terms.html \
  'Terms CryptScan section should use the short product name'

require '<h2 id="cryptscan">3. CryptScan</h2>' \
  acknowledgements.html \
  'Acknowledgements section should use the short product name'

require 'long-term vault for important documents' \
  index.html \
  'Homepage card should position CryptScan as long-term document storage'

require 'passports, driver'\''s licenses, IDs, forms, and paper files' \
  apps/cryptscan.html \
  'CryptScan detail page should name important document examples'

require 'local document vault' \
  privacy.html \
  'Privacy policy should describe CryptScan storage as a local document vault'

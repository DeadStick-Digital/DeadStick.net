#!/usr/bin/env bash
set -euo pipefail

require() {
  local pattern="$1"
  local file="$2"
  local message="$3"

  if ! git grep -q "$pattern" -- "$file"; then
    printf 'Missing expected VoyageVault product name: %s\n' "$message" >&2
    exit 1
  fi
}

require '<div class="app-tag">Document Scanner and Vault</div>' \
  index.html \
  'Homepage card should use Document Scanner and Vault as the category label'

require '<h3>VoyageVault</h3>' \
  index.html \
  'Homepage card should use the short VoyageVault product name'

require '<li><a href="apps/pitot.html">VoyageVault</a></li>' \
  index.html \
  'Homepage footer app list should use the short VoyageVault product name'

require '<title>VoyageVault — DeadStick Digital LLC</title>' \
  apps/pitot.html \
  'VoyageVault detail page title should use the short product name'

require 'Coming soon · Document Scanner and Vault' \
  apps/pitot.html \
  'VoyageVault detail page eyebrow should use Document Scanner and Vault'

require '<h1>VoyageVault</h1>' \
  apps/pitot.html \
  'VoyageVault detail page hero should use the short product name'

require '<a href="apps/pitot.html">VoyageVault</a>' \
  support.html \
  'Support page app list should use the short product name'

require '<strong>VoyageVault</strong>' \
  privacy.html \
  'Privacy app list should use the short product name'

require '<h2 id="voyagevault">VoyageVault</h2>' \
  deletion.html \
  'Deletion page heading should use the short product name'

require '<h3 id="apps-voyagevault">14.4 VoyageVault</h3>' \
  terms.html \
  'Terms VoyageVault section should use the short product name'

require '<h2 id="voyagevault">4. VoyageVault</h2>' \
  acknowledgements.html \
  'Acknowledgements section should use the short product name'

require 'long-term vault for important documents' \
  index.html \
  'Homepage card should position VoyageVault as long-term document storage'

require 'passports, driver'\''s licenses, IDs, forms, and paper files' \
  apps/pitot.html \
  'VoyageVault detail page should name important document examples'

require 'local document vault' \
  privacy.html \
  'Privacy policy should describe VoyageVault storage as a local document vault'

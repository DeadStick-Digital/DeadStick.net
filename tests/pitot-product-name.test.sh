#!/usr/bin/env bash
set -euo pipefail

require() {
  local pattern="$1"
  local file="$2"
  local message="$3"

  if ! git grep -q "$pattern" -- "$file"; then
    printf 'Missing expected Pitot product name: %s\n' "$message" >&2
    exit 1
  fi
}

require '<div class="app-tag">Document Scanner and Vault</div>' \
  index.html \
  'Homepage card should use Document Scanner and Vault as the category label'

require '<h3>Pitot</h3>' \
  index.html \
  'Homepage card should use the short Pitot product name'

require '<li><a href="apps/pitot.html">Pitot</a></li>' \
  index.html \
  'Homepage footer app list should use the short Pitot product name'

require '<title>Pitot — DeadStick Digital LLC</title>' \
  apps/pitot.html \
  'Pitot detail page title should use the short product name'

require 'Coming soon · Document Scanner and Vault' \
  apps/pitot.html \
  'Pitot detail page eyebrow should use Document Scanner and Vault'

require '<h1>Pitot</h1>' \
  apps/pitot.html \
  'Pitot detail page hero should use the short product name'

require '<a href="apps/pitot.html">Pitot</a>' \
  support.html \
  'Support page app list should use the short product name'

require '<strong>Pitot</strong>' \
  privacy.html \
  'Privacy app list should use the short product name'

require '<h2 id="pitot">Pitot</h2>' \
  deletion.html \
  'Deletion page heading should use the short product name'

require '<h3 id="apps-pitot">14.4 Pitot</h3>' \
  terms.html \
  'Terms Pitot section should use the short product name'

require '<h2 id="pitot">4. Pitot</h2>' \
  acknowledgements.html \
  'Acknowledgements section should use the short product name'

require 'long-term vault for important documents' \
  index.html \
  'Homepage card should position Pitot as long-term document storage'

require 'passports, driver'\''s licenses, IDs, forms, and paper files' \
  apps/pitot.html \
  'Pitot detail page should name important document examples'

require 'local document vault' \
  privacy.html \
  'Privacy policy should describe Pitot storage as a local document vault'

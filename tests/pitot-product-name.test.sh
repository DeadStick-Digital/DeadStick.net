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

require '<h3>Pitot Document Scanner and Vault</h3>' \
  index.html \
  'Homepage card should use the full Pitot product name'

require '<li><a href="apps/pitot.html">Pitot Document Scanner and Vault</a></li>' \
  index.html \
  'Homepage footer app list should use the full Pitot product name'

require '<title>Pitot Document Scanner and Vault — DeadStick Digital LLC</title>' \
  apps/pitot.html \
  'Pitot detail page title should use the full product name'

require '<h1>Pitot Document Scanner and Vault</h1>' \
  apps/pitot.html \
  'Pitot detail page hero should use the full product name'

require '<a href="apps/pitot.html">Pitot Document Scanner and Vault</a>' \
  support.html \
  'Support page app list should use the full product name'

require '<strong>Pitot Document Scanner and Vault</strong>' \
  privacy.html \
  'Privacy app list should use the full product name'

require '<h2 id="pitot">Pitot Document Scanner and Vault</h2>' \
  deletion.html \
  'Deletion page heading should use the full product name'

require '<h3 id="apps-pitot">14.4 Pitot Document Scanner and Vault</h3>' \
  terms.html \
  'Terms Pitot section should use the full product name'

require '<h2 id="pitot">4. Pitot Document Scanner and Vault</h2>' \
  acknowledgements.html \
  'Acknowledgements section should use the full product name'

require 'long-term vault for important documents' \
  index.html \
  'Homepage card should position Pitot as long-term document storage'

require 'passports, driver'\''s licenses, IDs, forms, and paper files' \
  apps/pitot.html \
  'Pitot detail page should name important document examples'

require 'local document vault' \
  privacy.html \
  'Privacy policy should describe Pitot storage as a local document vault'

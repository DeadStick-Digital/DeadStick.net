#!/usr/bin/env bash
set -euo pipefail

require() {
  local pattern="$1"
  local file="$2"
  local message="$3"

  if ! git grep -q "$pattern" -- "$file"; then
    printf 'Missing expected Voyage Vault product name: %s\n' "$message" >&2
    exit 1
  fi
}

require '<div class="app-tag">Document Scanner and Vault</div>' \
  index.html \
  'Homepage card should use Document Scanner and Vault as the category label'

require '<h3>Voyage Vault</h3>' \
  index.html \
  'Homepage card should use the short Voyage Vault product name'

require '<li><a href="apps/pitot.html">Voyage Vault</a></li>' \
  index.html \
  'Homepage footer app list should use the short Voyage Vault product name'

require '<title>Voyage Vault — DeadStick Digital LLC</title>' \
  apps/pitot.html \
  'Voyage Vault detail page title should use the short product name'

require 'Coming soon · Document Scanner and Vault' \
  apps/pitot.html \
  'Voyage Vault detail page eyebrow should use Document Scanner and Vault'

require '<h1>Voyage Vault</h1>' \
  apps/pitot.html \
  'Voyage Vault detail page hero should use the short product name'

require '<a href="apps/pitot.html">Voyage Vault</a>' \
  support.html \
  'Support page app list should use the short product name'

require '<strong>Voyage Vault</strong>' \
  privacy.html \
  'Privacy app list should use the short product name'

require '<h2 id="voyage-vault">Voyage Vault</h2>' \
  deletion.html \
  'Deletion page heading should use the short product name'

require '<h3 id="apps-voyage-vault">14.4 Voyage Vault</h3>' \
  terms.html \
  'Terms Voyage Vault section should use the short product name'

require '<h2 id="voyage-vault">4. Voyage Vault</h2>' \
  acknowledgements.html \
  'Acknowledgements section should use the short product name'

require 'long-term vault for important documents' \
  index.html \
  'Homepage card should position Voyage Vault as long-term document storage'

require 'passports, driver'\''s licenses, IDs, forms, and paper files' \
  apps/pitot.html \
  'Voyage Vault detail page should name important document examples'

require 'local document vault' \
  privacy.html \
  'Privacy policy should describe Voyage Vault storage as a local document vault'

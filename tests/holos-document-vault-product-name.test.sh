#!/usr/bin/env bash
set -euo pipefail

require() {
  local pattern="$1"
  local file="$2"
  local message="$3"

  if ! git grep -q "$pattern" -- "$file"; then
    printf 'Missing expected Holos Document Vault product name: %s\n' "$message" >&2
    exit 1
  fi
}

require '<div class="app-tag">Secure Document Scanner</div>' \
  index.html \
  'Homepage card should use Secure Document Scanner as the category label'

require '<h3>Holos Document Vault</h3>' \
  index.html \
  'Homepage card should use the short Holos Document Vault product name'

require '<li><a href="apps/holos-document-vault.html">Holos Document Vault</a></li>' \
  index.html \
  'Homepage footer app list should use the short Holos Document Vault product name'

require '<title>Holos Document Vault — DeadStick Digital LLC</title>' \
  apps/holos-document-vault.html \
  'Holos Document Vault detail page title should use the short product name'

require 'Coming soon · Secure Document Scanner' \
  apps/holos-document-vault.html \
  'Holos Document Vault detail page eyebrow should use Secure Document Scanner'

require '<h1>Holos Document Vault</h1>' \
  apps/holos-document-vault.html \
  'Holos Document Vault detail page hero should use the short product name'

require '<a href="apps/holos-document-vault.html">Holos Document Vault</a>' \
  support.html \
  'Support page app list should use the short product name'

require '<strong>Holos Document Vault</strong>' \
  privacy.html \
  'Privacy app list should use the short product name'

require '<h2 id="holos-document-vault">Holos Document Vault</h2>' \
  deletion.html \
  'Deletion page heading should use the short product name'

require '<h3 id="apps-holos-document-vault">14.3 Holos Document Vault</h3>' \
  terms.html \
  'Terms Holos Document Vault section should use the short product name'

require '<h2 id="holos-document-vault">3. Holos Document Vault</h2>' \
  acknowledgements.html \
  'Acknowledgements section should use the short product name'

require 'long-term vault for important documents' \
  index.html \
  'Homepage card should position Holos Document Vault as long-term document storage'

require 'passports, driver'\''s licenses, IDs, forms, and paper files' \
  apps/holos-document-vault.html \
  'Holos Document Vault detail page should name important document examples'

require 'local document vault' \
  privacy.html \
  'Privacy policy should describe Holos Document Vault storage as a local document vault'

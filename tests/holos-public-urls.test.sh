#!/usr/bin/env bash
set -euo pipefail

require() {
  local pattern="$1"
  local file="$2"
  local message="$3"

  if ! grep -q "$pattern" "$file"; then
    printf 'Missing expected Holos public URL copy: %s\n' "$message" >&2
    exit 1
  fi
}

reject() {
  local pattern="$1"
  local file="$2"
  local message="$3"

  if grep -q "$pattern" "$file"; then
    printf 'Blocked Holos public URL copy found: %s\n' "$message" >&2
    exit 1
  fi
}

pages=(
  holos/privacy/index.html
  holos/terms/index.html
  holos/support/index.html
  holos/data-deletion/index.html
  holos/forgotten-pin/index.html
  holos/sync-recovery/index.html
  holos/evidence-retention/index.html
  holos/incident-support/index.html
)

for page in "${pages[@]}"; do
  test -f "$page"
  require 'Holos Document Vault' "$page" "$page should identify the product"
  require 'DeadStick Digital' "$page" "$page should identify DeadStick"
  require 'styles.css?v=20260629-holos-public-urls' "$page" "$page should use the Holos public URL stylesheet version"
  reject '\[TBD\]' "$page" "$page should not publish bracket placeholders"
  reject '100% secure' "$page" "$page should avoid impossible security claims"
  reject 'FIPS validated' "$page" "$page should avoid unsupported FIPS claims"
  reject 'government approved' "$page" "$page should avoid unsupported government claims"
done

require 'does not collect vault documents' \
  holos/privacy/index.html \
  'privacy page should preserve the no-vault-content collection boundary'

require 'App Store or Google Play purchases, RevenueCat entitlement validation, and Supabase Auth account linking' \
  holos/privacy/index.html \
  'privacy page should disclose paid subscription services'

require 'The optional app PIN controls app access. It does not encrypt the local vault database by itself.' \
  holos/privacy/index.html \
  'privacy page should avoid claiming PIN-derived encryption'

require 'Users keep ownership of the documents, scans, OCR text, translations, tags, metadata, and exports' \
  holos/terms/index.html \
  'terms page should preserve user-content ownership language'

require 'Local-only data may be lost if the device is lost, reset, repaired, damaged, or if app data is removed' \
  holos/terms/index.html \
  'terms page should include backup responsibility language'

require 'Cloud providers' \
  holos/terms/index.html \
  'terms page should cover provider responsibility'

require '../data-deletion/' holos/support/index.html 'support page should link data deletion'
require '../forgotten-pin/' holos/support/index.html 'support page should link forgotten PIN'
require '../sync-recovery/' holos/support/index.html 'support page should link sync recovery'
require '../evidence-retention/' holos/support/index.html 'support page should link evidence retention'
require '../incident-support/' holos/support/index.html 'support page should link incident support'

require 'data deletion' holos/data-deletion/index.html 'data deletion page should include topic wording'
require 'account deletion' holos/data-deletion/index.html 'data deletion page should cover account deletion'
require 'subscription account records' holos/data-deletion/index.html 'data deletion page should cover subscription account boundaries'

require 'Forgotten PIN' holos/forgotten-pin/index.html 'forgotten PIN page should include topic wording'
require 'support cannot bypass or clear a stored PIN' holos/forgotten-pin/index.html 'forgotten PIN page should preserve no-support-recovery boundary'

require 'Sync Recovery' holos/sync-recovery/index.html 'sync recovery page should include topic wording'
require 'Safety' holos/sync-recovery/index.html 'sync recovery page should include safety snapshot guidance'

require 'Evidence Retention' holos/evidence-retention/index.html 'evidence retention page should include topic wording'
require 'within 180 days' holos/evidence-retention/index.html 'evidence retention page should include release evidence retention boundary'

require 'Incident Support' holos/incident-support/index.html 'incident support page should include topic wording'
require 'does not claim a certified incident-response program' holos/incident-support/index.html 'incident support page should avoid unsupported certification claims'

require '../holos/support/' \
  apps/holos-document-vault.html \
  'Holos product page should link product-specific support'

require '../holos/privacy/' \
  apps/holos-document-vault.html \
  'Holos product page should link product-specific privacy details'

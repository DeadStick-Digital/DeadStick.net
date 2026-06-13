#!/usr/bin/env bash
set -euo pipefail

require() {
  local pattern="$1"
  local file="$2"
  local message="$3"

  if ! grep -q "$pattern" "$file"; then
    printf 'Missing expected Holos Drive Vault store-compliance copy: %s\n' "$message" >&2
    exit 1
  fi
}

require '<title>Holos Drive Vault — DeadStick Digital LLC</title>' \
  apps/holos-drive-vault.html \
  'detail page should use the Holos Drive Vault product name'

require '<h1>Holos Drive Vault</h1>' \
  apps/holos-drive-vault.html \
  'detail page should have a clear app-page headline'

require 'Holos Drive Vault is separate from Holos Document Vault' \
  apps/holos-drive-vault.html \
  'detail page should explicitly distinguish the two Holos apps'

require 'Why Holos Drive Vault is safe and secure' \
  apps/holos-drive-vault.html \
  'detail page should include the requested security bullet section'

require 'No DeadStick recovery-key server' \
  apps/holos-drive-vault.html \
  'security bullets should lead with no key escrow'

require 'OS-backed key storage' \
  apps/holos-drive-vault.html \
  'security bullets should mention operating-system credential storage'

require 'Biometric data stays on device' \
  apps/holos-drive-vault.html \
  'security bullets should mention biometric privacy'

require 'No accounts, ads, or telemetry' \
  apps/holos-drive-vault.html \
  'security bullets should mention no accounts, ads, or telemetry'

require '../privacy.html#apps-holos-drive-vault' \
  apps/holos-drive-vault.html \
  'detail page should link to app-specific privacy details'

require '../deletion.html#holos-drive-vault' \
  apps/holos-drive-vault.html \
  'detail page should link to data deletion details'

require '<li><a href="apps/holos-drive-vault.html">Holos Drive Vault</a>' \
  support.html \
  'support page should list Holos Drive Vault separately'

require '<h3 id="apps-holos-drive-vault">10.4 Holos Drive Vault</h3>' \
  privacy.html \
  'privacy policy should include a Holos Drive Vault app-specific section'

require '<h2 id="holos-drive-vault">Holos Drive Vault</h2>' \
  deletion.html \
  'deletion page should include Holos Drive Vault deletion instructions'

require '<h3 id="apps-holos-drive-vault">14.4 Holos Drive Vault</h3>' \
  terms.html \
  'terms should include Holos Drive Vault destructive-formatting terms'

require '<h2 id="holos-drive-vault">4. Holos Drive Vault</h2>' \
  acknowledgements.html \
  'acknowledgements should include Holos Drive Vault platform dependencies'
